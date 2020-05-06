//
//  GeoActionTableViewCell.swift
//  Geo
//
//  Created by Иван Алексеев on 21/06/2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import MobileCoreServices

class GeoActionTableViewCell : UITableViewCell {
	
	var location: CLLocation? = nil
	var viewController: ViewController? = nil
	
	@IBOutlet var btnMap: UIButton!
	@IBOutlet var btnShare: UIButton!

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialize()
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		initialize()
	}
	
	private func initialize() {
		selectionStyle = UITableViewCell.SelectionStyle.none
		backgroundColor = UIColor.clear
	}
	
	private func prepareView(_ btn: UIButton) {
		btn.roundCorners(radius: 4)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		self.accessoryType = .none
		self.prepareView(self.btnMap)
		self.prepareView(self.btnShare)
	}
	
	@IBAction func openMap() {
		let currentLocationMapItem: MKMapItem = MKMapItem.forCurrentLocation()
		MKMapItem.openMaps(with: [currentLocationMapItem], launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
	}

	@IBAction func shareLocation() {
		guard let loc = location else {
			print("nothing to share")
			return
		}
		
		let locationTitle = "latitude: \(loc.coordinate.latitude)\nlongitude: \(loc.coordinate.longitude)"
		let url = URL(string: "http://maps.apple.com/?ll=\(loc.coordinate.latitude),\(loc.coordinate.longitude)")
		guard let u = url else {
			return
		}
		
		let shareItems: [Any] = [loc, u, locationTitle]
		
		let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
		activityViewController.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.airDrop, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.mail, UIActivity.ActivityType.markupAsPDF, UIActivity.ActivityType.message, UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.postToFlickr, UIActivity.ActivityType.postToTencentWeibo, UIActivity.ActivityType.postToTwitter, UIActivity.ActivityType.postToVimeo, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.print, UIActivity.ActivityType.saveToCameraRoll]
		viewController?.present(activityViewController, animated: true, completion: nil)
	}

}
