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
	
	@IBOutlet var graphView: GraphView!
	
	var graphPointsAltitudeBar: [Int] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = NSLocalizedString("Graph", comment: "")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.setupGraphDisplay()
	}
	
	func setupGraphDisplay() {
		
		let maxDayIndex = graphView.svLabelsY.arrangedSubviews.count - 1
		
		graphView.graphPoints = graphPointsAltitudeBar
		graphView.setNeedsDisplay()
		graphView.lblMaxY.text = "\(graphView.graphPoints.max()!)"
		
		graphView.lblTitle.text = NSLocalizedString("Altitude (Bar)", comment: "")
		
		let average = graphView.graphPoints.reduce(0, +) / graphView.graphPoints.map({ (_ a: Int) -> Int in
			return a > 0 ? 1 : a
		}).reduce(0, +)
		graphView.lblAggregateTitle.text = NSLocalizedString("Average", comment: "")
		graphView.lblAggregateValue.text = "\(average)"
		
		let today = Date()
		let calendar = Calendar.current
		
		let formatter = DateFormatter()
		formatter.setLocalizedDateFormatFromTemplate("EEEEE")
		
		for i in 0...maxDayIndex {
			if let date = calendar.date(byAdding: .day, value: -i, to: today),
				let label = graphView.svLabelsY.arrangedSubviews[maxDayIndex - i] as? UILabel {
				label.text = formatter.string(from: date)
			}
		}
	}
}
