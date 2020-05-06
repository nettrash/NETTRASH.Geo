//
//  AddMarkViewController.swift
//  Geo
//
//  Created by Иван Алексеев on 06.05.2020.
//  Copyright © 2020 NETTRASH. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddMarkViewController : UIViewController {
	
	private var trace: Trace? = nil
	@IBOutlet var markerName: UITextField!
	@IBOutlet var lblTitle: UILabel!
	@IBOutlet var lblHeight: UILabel!
	@IBOutlet var lblPressure: UILabel!
	@IBOutlet var lblEverest: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = NSLocalizedString("Add marker", comment: "")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.initialize()
		self.lblTitle.text = title
		roundButtons(view: self.view, radius: 8)
	}
	
	private func roundButtons(view: UIView?, radius: Int) {
		if (view == nil) { return }
		if (view is UIButton) {
			(view as! UIButton).roundCorners(radius: radius)
		} else {
			if (view?.subviews.count ?? 0 > 0) {
				view!.subviews.forEach { v in
					roundButtons(view: v, radius: radius)
				}
			}
		}
	}
	
	private func initialize() {
		let app = UIApplication.shared.delegate as! AppDelegate
		let moc = app.persistentContainer.viewContext
		let traces = try? moc.fetch(Trace.lastTraceFetchRequest()) as [Trace]
		if (traces?.count ?? 0 > 0) {
			trace = traces?.first
			
			self.lblHeight.text = String(format: NSLocalizedString("%.0fm according to the barometer", comment: ""), trace!.altitudeBAR)
			self.lblPressure.text = String(format: NSLocalizedString("%.4f kPa %.4f mm Hg %.4f atm", comment: ""), trace!.pressure, trace!.pressure * 7.50062, trace!.pressure / 101.325)
			let everestPercentText = String(format: "%.4f", trace!.everest)
			self.lblEverest.text = everestPercentText + NSLocalizedString("%🏔 (Everest)", comment: "")
		}

		self.markerName.attributedPlaceholder = NSAttributedString(
			string: NSLocalizedString("Add marker placeholder", comment: "Add marker placeholder"),
			attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray]
		)

		self.markerName.text = ""
	}
	
	@objc @IBAction func cancelMarker() {
		self.dismiss(animated: true, completion: nil)
	}
	
	@objc @IBAction func saveMarker() {
		if (self.markerName.text ?? "" == "") {
			let alert = UIAlertController(
				title: NSLocalizedString("Error", comment: ""),
				message: NSLocalizedString("Marker name is empty", comment: ""),
				preferredStyle: UIAlertController.Style.actionSheet)
			alert.addAction(
				UIAlertAction(
					title: NSLocalizedString("Continue", comment: ""),
					style: UIAlertAction.Style.default,
					handler: { (_ action: UIAlertAction) in
				
					}
				)
			)
			self.present(alert, animated: true) {
				DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
					if self.presentedViewController == alert {
						self.dismiss(animated: true) { }
					}
				}
			}
			return
		}
		
		self.markerName.resignFirstResponder()

		let app = UIApplication.shared.delegate as! AppDelegate
		let moc = app.persistentContainer.viewContext
		let mark = NSEntityDescription.insertNewObject(forEntityName: "Mark", into: moc) as! Mark
		mark.date = trace!.date
		mark.day = trace!.day
		mark.altitudeBAR = trace!.altitudeBAR
		mark.altitudeGPS = trace!.altitudeGPS
		mark.latitude = trace!.latitude
		mark.longitude = trace!.longitude
		mark.pressure = trace!.pressure
		mark.everest = trace!.everest
		mark.name = self.markerName.text ?? "\(NSLocalizedString("MarkName", comment: "MarkName"))  \(trace?.date ?? Date() as NSDate)"
		mark.message = ""
		try? moc.save()
		self.dismiss(animated: true, completion: nil)
	}

}
