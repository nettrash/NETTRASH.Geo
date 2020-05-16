//
//  AppDelegate.swift
//  Geo
//
//  Created by Иван Алексеев on 13/05/2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//

import UIKit
import WatchConnectivity
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var bar: Barometer?
	lazy var persistentContainer: PersistentContainer = {
		let container = PersistentContainer(name: "Geo")
		
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		self.bar = Barometer()
		self.bar?.Start()
		if WCSession.isSupported() {
			WCSession.default.delegate = self
			WCSession.default.activate()
		}

		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
}

extension AppDelegate: WCSessionDelegate {
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
	}

	func sessionDidBecomeInactive(_ session: WCSession) {
		
	}

	func sessionDidDeactivate(_ session: WCSession) {
		
	}
	
	func sessionWatchStateDidChange(_ session: WCSession) {
		
	}
	
	func sessionReachabilityDidChange(_ session: WCSession) {
		
	}

	func session(_ session: WCSession, didReceive file: WCSessionFile) {
		
	}
	
	func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
		
	}

	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		
		do {
			let moc = persistentContainer.viewContext
			let traces = try? moc.fetch(Trace.fetchRequest()) as [Trace]
			
			if (traces != nil) {
				var lastTrace: Trace? = nil
				if traces!.count > 0 { lastTrace = traces![traces!.count-1] }
				var date = message["date"] as! Date
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
				if lastTrace != nil && lastTrace!.date != nil && lastTrace!.date! as Date == date {
					lastTrace!.altitudeBAR = message["altitudeBAR"] as! Double
					lastTrace!.pressure = message["pressure"] as! Double
					lastTrace!.everest = message["everest"] as! Double
					try? moc.save()
				} else if minuteDelta == 0 || mDiff > 9 || lastTrace == nil {
					let trace = NSEntityDescription.insertNewObject(forEntityName: "Trace", into: moc) as! Trace
					trace.date = date as NSDate
					trace.day = d as NSDate
					trace.altitudeBAR = message["altitudeBAR"] as! Double
					trace.pressure = message["pressure"] as! Double
					trace.everest = message["everest"] as! Double
					try? moc.save()
				}
			}
		}
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
