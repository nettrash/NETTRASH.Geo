//
//  ExtensionDelegate.swift
//  Geo WatchKit Extension
//
//  Created by Иван Алексеев on 13/05/2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//

import WatchKit
import CoreData
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate {

	let bar: WatchBarometer = WatchBarometer()
	let weather: Weather = Weather()
	var lastSendTraceToApp: Date? = nil
	public var persistentContainer: PersistentContainer = {
		let container = PersistentContainer(name: "Geo")
		container.loadPersistentStores(completionHandler: { (storeDescription:NSPersistentStoreDescription, error:Error?) in
			if let error = error as NSError?{
				fatalError("UnResolved error \(error), \(error.userInfo)")
			}
		})
		
		return container
	}()

	override init() {
		super.init()
		
		WCSession.default.delegate = self
        WCSession.default.activate()
	}
	
	private func sendTraceToApp(_ trace: Trace) {
		if WCSession.isSupported() && sendToAppAvailable() {
			var msg: [String: Any] = [:]
			msg["date"] = trace.date
			msg["day"] = trace.day
			msg["latitude"] = trace.latitude
			msg["longitude"] = trace.longitude
			msg["altitudeGPS"] = trace.altitudeGPS
			msg["altitudeBAR"] = trace.altitudeBAR
			msg["everest"] = trace.everest
			msg["pressure"] = trace.pressure
			WCSession.default.sendMessage(msg, replyHandler: nil, errorHandler: nil)
		}
	}
	
	private func sendToAppAvailable() -> Bool {
		if lastSendTraceToApp == nil {
			lastSendTraceToApp = Date()
			return true
		}
		let diff = Calendar.current.dateComponents([.minute], from: lastSendTraceToApp!, to: Date())
		if diff.minute! > 5 {
			lastSendTraceToApp = Date()
			return true
		}
		return false
	}
	
	private func clockRefresh() {
		let fireDate = Date(timeIntervalSinceNow: 60)
		let ext = WKExtension.shared()
		ext.scheduleBackgroundRefresh(withPreferredDate: fireDate, userInfo: nil) { (_ error: Error?) in
			if error == nil {
			}
		}
	}
	
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
		lastSendTraceToApp = nil
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		self.bar.Start()
		clockRefresh()
		lastSendTraceToApp = nil
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
		//self.bar.Stop()
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
				self.bar.Start()
				self.refreshComplication()
                backgroundTask.setTaskCompletedWithSnapshot(false)
				self.clockRefresh()
				self.traceBarometer()
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }

	func refreshComplication() {
		let server = CLKComplicationServer.sharedInstance()
		if server.activeComplications != nil {
			for c in server.activeComplications! {
				server.reloadTimeline(for: c)
			}
		}
	}
	
	func traceBarometer() {
			let everestPercent = 100.0 * self.bar.everest
			let barAltitude = self.bar.height
			let barPressure = self.bar.pressure
			
			let moc = self.persistentContainer.viewContext
			let traces = try? moc.fetch(Trace.fetchRequest()) as [Trace]
			
			if (traces != nil) {
				var lastTrace: Trace? = nil
				if traces!.count > 0 { lastTrace = traces![traces!.count-1] }
				var date = Date()
				let calendar = Calendar.current
				var minute = calendar.component(.minute, from: date)
				var second = calendar.component(.second, from: date)
				var nanosecond = calendar.component(.nanosecond, from: date)
				var minuteDelta = minute - 10 * (minute / 10)
				date = calendar.date(byAdding: .nanosecond, value: -nanosecond, to: date)!
				date = calendar.date(byAdding: .second, value: -second, to: date)!
				date = calendar.date(byAdding: .minute, value: -minuteDelta, to: date)!
				
				var d = Date()
				let hour = calendar.component(.hour, from: d)
				minute = calendar.component(.minute, from: d)
				second = calendar.component(.second, from: d)
				nanosecond = calendar.component(.nanosecond, from: d)
				minuteDelta = minute - 10 * (minute / 10)
				d = calendar.date(byAdding: .nanosecond, value: -nanosecond, to: d)!
				d = calendar.date(byAdding: .second, value: -second, to: d)!
				d = calendar.date(byAdding: .minute, value: -minute, to: d)!
				d = calendar.date(byAdding: .hour, value: -hour, to: d)!
				
				var mDiff = 0
				if lastTrace != nil && lastTrace!.date != nil {
					let diff = calendar.dateComponents([.minute], from: lastTrace!.date! as Date, to: date)
					mDiff = diff.minute!
				}
				if lastTrace != nil && lastTrace?.date != nil && lastTrace!.date! as Date == date {
					lastTrace!.altitudeBAR = barAltitude
					lastTrace!.pressure = barPressure
					lastTrace!.everest = everestPercent
					sendTraceToApp(lastTrace!)
					try? moc.save()
				} else if minuteDelta == 0 || mDiff > 9 || lastTrace == nil {
					let trace = NSEntityDescription.insertNewObject(forEntityName: "Trace", into: moc) as! Trace
					trace.date = date as NSDate
					trace.day = d as NSDate
					trace.altitudeBAR = barAltitude
					trace.pressure = barPressure
					trace.everest = everestPercent
					sendTraceToApp(trace)
					try? moc.save()
				}
				
				if traces!.count > 10000 {
					moc.delete(traces![0])
					try? moc.save()
				}
			}
	}

}

extension ExtensionDelegate: WCSessionDelegate {
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
	}

	func sessionReachabilityDidChange(_ session: WCSession) {
		
	}

	func session(_ session: WCSession, didReceive file: WCSessionFile) {
		
	}
	
	func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
		
	}

	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		
	}
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
		
	}

	func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
		
	}
	
	func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
		
	}

	func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
		
	}
	
	func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
		
	}

	func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
		
	}

}
