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
		
	private var graphPointsAltitudeBar: [Int] = []
	private var graphPointsPressure: [Int] = []
	private var graphPointsEverest: [Int] = []
	private var maxDay: Date = Date()
	private var minDay: Date = Date()

	@IBOutlet var graphViewAltitudeBar: GraphView!
	@IBOutlet var graphViewPressure: GraphView!
	@IBOutlet var graphViewEverest: GraphView!

	private func setupGraphDisplay() {
		
		initializeData()
		setupGraphAltitudeBar()
		setupGraphPressure()
		setupGraphEverest()
		
	}
	
	private func initializeData() {
		#if targetEnvironment(simulator)
		
		graphPointsAltitudeBar = [190, 313, 323, 306, 265, 233, 211]
		graphPointsPressure = [98, 97, 97, 97, 98, 98, 98]
		graphPointsEverest = [1, 3, 3, 3, 2, 2, 2]

		#else
		
		let nMaxCount = 31
		let app = UIApplication.shared.delegate as! AppDelegate
		let moc = app.persistentContainer.viewContext
		if let traces: [Dictionary<String, Any>] = try? moc.fetch(Trace.weekAggregateFetchRequest(nMaxCount)) as? [Dictionary<String, Any>] {
		
			maxDay = traces[0]["day"] as! Date
			minDay = traces[(traces.count > nMaxCount ? nMaxCount - 1 : traces.count - 1)]["day"] as! Date
			var idx = traces.count
			var cnt = 0
			var pointsAltitudeBar: [Int] = []
			var pointsPressure: [Int] = []
			var pointsEverest: [Int] = []
			for _ in 0..<nMaxCount {
				pointsAltitudeBar.append(0)
				pointsPressure.append(0)
				pointsEverest.append(0)
			}
			//for 100% day by day
			/*
			let calendar = Calendar.current
			var day = Date()
			let hour = calendar.component(.hour, from: day)
			let minute = calendar.component(.minute, from: day)
			let second = calendar.component(.second, from: day)
			let nanosecond = calendar.component(.nanosecond, from: day)
			day = calendar.date(byAdding: .nanosecond, value: -nanosecond, to: day)!
			day = calendar.date(byAdding: .second, value: -second, to: day)!
			day = calendar.date(byAdding: .minute, value: -minute, to: day)!
			day = calendar.date(byAdding: .hour, value: -hour, to: day)!*/
			while idx > 0 && cnt < nMaxCount {
				idx -= 1
				cnt += 1
				/*if let element = traces?.first(where: { (item: Dictionary<String, Any>) -> Bool in
					return item["day"] as! Date == day
				}) {*/
				let element = traces[idx]
				pointsAltitudeBar[nMaxCount-cnt] = Int(element["maxAltitudeBAR"] as! Double)
				pointsPressure[nMaxCount-cnt] = Int(element["minPressure"] as! Double)
				pointsEverest[nMaxCount-cnt] = Int(element["maxEverest"] as! Double)
				/*}
				day = calendar.date(byAdding: .day, value: -1, to: day)!*/
			}
			if cnt < nMaxCount && cnt > 0 {
				let pab = pointsAltitudeBar[nMaxCount-cnt]
				let pp = pointsPressure[nMaxCount-cnt]
				let pe = pointsEverest[nMaxCount-cnt]
				while cnt < nMaxCount {
					cnt += 1
					pointsAltitudeBar[nMaxCount-cnt] = pab
					pointsPressure[nMaxCount-cnt] = pp
					pointsEverest[nMaxCount-cnt] = pe
				}
			}
			graphPointsAltitudeBar = pointsAltitudeBar
			graphPointsPressure = pointsPressure
			graphPointsEverest = pointsEverest
		}
		#endif
	}
	
	private func setupGraphAltitudeBar() {
		
		let maxDayIndex = graphPointsAltitudeBar.count
		
		while graphViewAltitudeBar.svLabelsY.arrangedSubviews.count > 0 {
			graphViewAltitudeBar.svLabelsY.removeArrangedSubview(graphViewAltitudeBar.svLabelsY.arrangedSubviews[0])
		}
		
		for _ in 0..<maxDayIndex {
			let label = UILabel()
			graphViewAltitudeBar.svLabelsY.addArrangedSubview(label)
		}
		
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
		
		/*let today = Date()
		let calendar = Calendar.current
		*/
		let formatter = DateFormatter()
		/*formatter.setLocalizedDateFormatFromTemplate("EEEEE")
		
		for i in 1...maxDayIndex {
			if let date = calendar.date(byAdding: .day, value: -i, to: today),
				let label = graphViewAltitudeBar.svLabelsY.arrangedSubviews[maxDayIndex - i] as? UILabel {
				label.text = formatter.string(from: date)
			}
		}*/
		
		formatter.setLocalizedDateFormatFromTemplate("d LLL")
		/*if let startDate = calendar.date(byAdding: .day, value: -maxDayIndex, to: today) {
			graphViewAltitudeBar.lblStartX.text = formatter.string(from: startDate)
			let todayMonth = calendar.dateComponents([.month], from: today)
			let startMonth = calendar.dateComponents([.month], from: startDate)
			if todayMonth == startMonth {
				formatter.setLocalizedDateFormatFromTemplate("d")
			}
		}
		graphViewAltitudeBar.lblEndX.text = formatter.string(from: today)*/
		graphViewAltitudeBar.lblStartX.text = formatter.string(from: minDay)
		graphViewAltitudeBar.lblEndX.text = formatter.string(from: maxDay)
	}
	
	private func setupGraphPressure() {
		
		let maxDayIndex = graphPointsPressure.count
		
		while graphViewPressure.svLabelsY.arrangedSubviews.count > 0 {
			graphViewPressure.svLabelsY.removeArrangedSubview(graphViewPressure.svLabelsY.arrangedSubviews[0])
		}
		
		for _ in 0..<maxDayIndex {
			let label = UILabel()
			graphViewPressure.svLabelsY.addArrangedSubview(label)
		}

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
		
		/*let today = Date()
		let calendar = Calendar.current
		*/
		let formatter = DateFormatter()
		/*formatter.setLocalizedDateFormatFromTemplate("EEEEE")
		
		for i in 1...maxDayIndex {
			if let date = calendar.date(byAdding: .day, value: -i, to: today),
				let label = graphViewPressure.svLabelsY.arrangedSubviews[maxDayIndex - i] as? UILabel {
				label.text = formatter.string(from: date)
			}
		}*/
		
		formatter.setLocalizedDateFormatFromTemplate("d LLL")
		/*if let startDate = calendar.date(byAdding: .day, value: -maxDayIndex, to: today) {
			graphViewPressure.lblStartX.text = formatter.string(from: startDate)
			let todayMonth = calendar.dateComponents([.month], from: today)
			let startMonth = calendar.dateComponents([.month], from: startDate)
			if todayMonth == startMonth {
				formatter.setLocalizedDateFormatFromTemplate("d")
			}
		}
		graphViewPressure.lblEndX.text = formatter.string(from: today)*/
		graphViewPressure.lblStartX.text = formatter.string(from: minDay)
		graphViewPressure.lblEndX.text = formatter.string(from: maxDay)
	}
	
	private func setupGraphEverest() {
		
		let maxDayIndex = graphPointsEverest.count
		
		while graphViewEverest.svLabelsY.arrangedSubviews.count > 0 {
			graphViewEverest.svLabelsY.removeArrangedSubview(graphViewEverest.svLabelsY.arrangedSubviews[0])
		}
		
		for _ in 0..<maxDayIndex {
			let label = UILabel()
			graphViewEverest.svLabelsY.addArrangedSubview(label)
		}
		
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
		
		/*let today = Date()
		let calendar = Calendar.current
		*/
		let formatter = DateFormatter()
		/*formatter.setLocalizedDateFormatFromTemplate("EEEEE")
		
		for i in 1...maxDayIndex {
			if let date = calendar.date(byAdding: .day, value: -i, to: today),
				let label = graphViewEverest.svLabelsY.arrangedSubviews[maxDayIndex - i] as? UILabel {
				label.text = formatter.string(from: date)
			}
		}*/
		
		formatter.setLocalizedDateFormatFromTemplate("d LLL")
		/*if let startDate = calendar.date(byAdding: .day, value: -maxDayIndex, to: today) {
			graphViewEverest.lblStartX.text = formatter.string(from: startDate)
			let todayMonth = calendar.dateComponents([.month], from: today)
			let startMonth = calendar.dateComponents([.month], from: startDate)
			if todayMonth == startMonth {
				formatter.setLocalizedDateFormatFromTemplate("d")
			}
		}
		graphViewEverest.lblEndX.text = formatter.string(from: today)*/
		graphViewEverest.lblStartX.text = formatter.string(from: minDay)
		graphViewEverest.lblEndX.text = formatter.string(from: maxDay)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = NSLocalizedString("Graph", comment: "")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 28)!, NSAttributedString.Key.foregroundColor: UIColor.lightGray]

		self.setupGraphDisplay()
	}
	
}
