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
		
		graphViewAltitudeBar.graphPoints = graphPointsAltitudeBar
		graphViewAltitudeBar.setNeedsDisplay()
		graphViewAltitudeBar.lblMaxY.text = "\(graphViewAltitudeBar.graphPoints.max()!)"
		
		graphViewAltitudeBar.lblTitle.text = NSLocalizedString("Altitude (Bar)", comment: "")
		
		let average = graphViewAltitudeBar.graphPoints.reduce(0, +) / graphViewAltitudeBar.graphPoints.map({ (_ a: Int) -> Int in
			return a > 0 ? 1 : a
		}).reduce(0, +)
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
	}
	
	func setupGraphPressure() {
		
		let maxDayIndex = graphViewPressure.svLabelsY.arrangedSubviews.count - 1
		
		graphViewPressure.graphPoints = graphPointsPressure
		graphViewPressure.setNeedsDisplay()
		graphViewPressure.lblMaxY.text = "\(graphViewPressure.graphPoints.max()!)"
		
		graphViewPressure.lblTitle.text = NSLocalizedString("Pressure", comment: "")
		
		let average = graphViewPressure.graphPoints.reduce(0, +) / graphViewPressure.graphPoints.map({ (_ a: Int) -> Int in
			return a > 0 ? 1 : a
		}).reduce(0, +)
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
	}
	
	func setupGraphEverest() {
		
		let maxDayIndex = graphViewEverest.svLabelsY.arrangedSubviews.count - 1
		
		graphViewEverest.graphPoints = graphPointsEverest
		graphViewEverest.setNeedsDisplay()
		graphViewEverest.lblMaxY.text = "\(graphViewEverest.graphPoints.max()!)"
		
		graphViewEverest.lblTitle.text = NSLocalizedString("Everest", comment: "")
		
		let average = graphViewEverest.graphPoints.reduce(0, +) / graphViewEverest.graphPoints.map({ (_ a: Int) -> Int in
			return a > 0 ? 1 : a
		}).reduce(0, +)
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
	}

}
