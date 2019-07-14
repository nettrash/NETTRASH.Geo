//
//  GraphViewController.swift
//  Geo
//
//  Created by Иван Алексеев on 10/07/2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//

import Foundation
import UIKit

class GraphViewController : UIViewController {
	
	@IBOutlet var graphViewAltitudeBar: GraphView!
	@IBOutlet var graphViewPressure: GraphView!
	@IBOutlet var graphViewEverest: GraphView!

	var graphPointsAltitudeBar: [Int] = []
	var graphPointsPressure: [Int] = []
	var graphPointsEverest: [Int] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = NSLocalizedString("Graph", comment: "")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 28)!, NSAttributedString.Key.foregroundColor: UIColor.lightGray]

		self.setupGraphDisplay()
	}
	
	func setupGraphDisplay() {
		
		setupGraphAltitudeBar()
		setupGraphPressure()
		setupGraphEverest()
		
	}
	
	func setupGraphAltitudeBar() {
		
		let maxDayIndex = graphViewAltitudeBar.svLabelsY.arrangedSubviews.count - 1
		
		let max = graphPointsAltitudeBar.max()!
		let min = graphPointsAltitudeBar.min()!
		
		graphViewAltitudeBar.graphPoints = graphPointsAltitudeBar.map({ (_ v: Int) -> Int in
			return v - min
		})
		graphViewAltitudeBar.setNeedsDisplay()
		graphViewAltitudeBar.lblMaxY.text = "\(max)"
		graphViewAltitudeBar.lblMinY.text = "\(min)"
		
		graphViewAltitudeBar.lblTitle.text = NSLocalizedString("Altitude (Bar)", comment: "")
		
		let average = graphPointsAltitudeBar.reduce(0, +) / graphPointsAltitudeBar.count
		graphViewAltitudeBar.lblAggregateTitle.text = NSLocalizedString("Average", comment: "")
		graphViewAltitudeBar.lblAggregateValue.text = "\(average)"
		
		let today = Date()
		let calendar = Calendar.current
		
		let formatter = DateFormatter()
		formatter.setLocalizedDateFormatFromTemplate("EEEEE")
		
		for i in 0...maxDayIndex {
			if let date = calendar.date(byAdding: .day, value: -i, to: today),
				let label = graphViewAltitudeBar.svLabelsY.arrangedSubviews[maxDayIndex - i] as? UILabel {
				label.text = formatter.string(from: date)
			}
		}
		
		formatter.setLocalizedDateFormatFromTemplate("d LLL")
		if let startDate = calendar.date(byAdding: .day, value: -maxDayIndex, to: today) {
			graphViewAltitudeBar.lblStartX.text = formatter.string(from: startDate)
			let todayMonth = calendar.dateComponents([.month], from: today)
			let startMonth = calendar.dateComponents([.month], from: startDate)
			if todayMonth == startMonth {
				formatter.setLocalizedDateFormatFromTemplate("d")
			}
		}
		graphViewAltitudeBar.lblEndX.text = formatter.string(from: today)
	}
	
	func setupGraphPressure() {
		
		let maxDayIndex = graphViewPressure.svLabelsY.arrangedSubviews.count - 1
		
		let max = graphPointsPressure.max()!
		let min = graphPointsPressure.min()!
		
		graphViewPressure.graphPoints = graphPointsPressure.map({ (_ v: Int) -> Int in
			return v - min
		})
		graphViewPressure.setNeedsDisplay()
		graphViewPressure.lblMaxY.text = "\(max)"
		graphViewPressure.lblMinY.text = "\(min)"

		graphViewPressure.lblTitle.text = NSLocalizedString("Pressure kPa", comment: "")
		
		let average = graphPointsPressure.reduce(0, +) / graphPointsPressure.count
		graphViewPressure.lblAggregateTitle.text = NSLocalizedString("Average", comment: "")
		graphViewPressure.lblAggregateValue.text = "\(average)"
		
		let today = Date()
		let calendar = Calendar.current
		
		let formatter = DateFormatter()
		formatter.setLocalizedDateFormatFromTemplate("EEEEE")
		
		for i in 0...maxDayIndex {
			if let date = calendar.date(byAdding: .day, value: -i, to: today),
				let label = graphViewPressure.svLabelsY.arrangedSubviews[maxDayIndex - i] as? UILabel {
				label.text = formatter.string(from: date)
			}
		}
		
		formatter.setLocalizedDateFormatFromTemplate("d LLL")
		if let startDate = calendar.date(byAdding: .day, value: -maxDayIndex, to: today) {
			graphViewPressure.lblStartX.text = formatter.string(from: startDate)
			let todayMonth = calendar.dateComponents([.month], from: today)
			let startMonth = calendar.dateComponents([.month], from: startDate)
			if todayMonth == startMonth {
				formatter.setLocalizedDateFormatFromTemplate("d")
			}
		}
		graphViewPressure.lblEndX.text = formatter.string(from: today)
	}
	
	func setupGraphEverest() {
		
		let maxDayIndex = graphViewEverest.svLabelsY.arrangedSubviews.count - 1
		
		let max = graphPointsEverest.max()!
		let min = graphPointsEverest.min()!
		
		graphViewEverest.graphPoints = graphPointsEverest.map({ (_ v: Int) -> Int in
			return v - min
		})
		graphViewEverest.setNeedsDisplay()
		graphViewEverest.lblMaxY.text = "\(max)"
		graphViewEverest.lblMinY.text = "\(min)"

		graphViewEverest.lblTitle.text = NSLocalizedString("Everest", comment: "")
		
		let average = graphPointsEverest.reduce(0, +) / graphPointsEverest.count
		graphViewEverest.lblAggregateTitle.text = NSLocalizedString("Average", comment: "")
		graphViewEverest.lblAggregateValue.text = "\(average)"
		
		let today = Date()
		let calendar = Calendar.current
		
		let formatter = DateFormatter()
		formatter.setLocalizedDateFormatFromTemplate("EEEEE")
		
		for i in 0...maxDayIndex {
			if let date = calendar.date(byAdding: .day, value: -i, to: today),
				let label = graphViewEverest.svLabelsY.arrangedSubviews[maxDayIndex - i] as? UILabel {
				label.text = formatter.string(from: date)
			}
		}
		
		formatter.setLocalizedDateFormatFromTemplate("d LLL")
		if let startDate = calendar.date(byAdding: .day, value: -maxDayIndex, to: today) {
			graphViewEverest.lblStartX.text = formatter.string(from: startDate)
			let todayMonth = calendar.dateComponents([.month], from: today)
			let startMonth = calendar.dateComponents([.month], from: startDate)
			if todayMonth == startMonth {
				formatter.setLocalizedDateFormatFromTemplate("d")
			}
		}
		graphViewEverest.lblEndX.text = formatter.string(from: today)
	}

}
