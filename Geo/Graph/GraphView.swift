//
//  GraphView.swift
//  Geo
//
//  Created by Иван Алексеев on 09/07/2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class GraphView : UIView {
	
	private struct Constants {
		static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
		static let margin: CGFloat = 20.0
		static let topBorder: CGFloat = 60
		static let bottomBorder: CGFloat = 50
		static let colorAlpha: CGFloat = 0.3
		static let circleDiameter: CGFloat = 5.0
	}
	
	@IBInspectable var bgStartColor: UIColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)//UIColor(red: 250/255, green: 233/255, blue: 222/255, alpha: 1)//UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
	@IBInspectable var bgEndColor: UIColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)//UIColor(red: 252/255, green: 79/255, blue: 8/255, alpha: 1)//UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
	
	@IBOutlet var lblTitle: UILabel!
	@IBOutlet var lblAggregateTitle: UILabel!
	@IBOutlet var lblAggregateValue: UILabel!
	@IBOutlet var lblMaxY: UILabel!
	@IBOutlet var lblMinY: UILabel!
	@IBOutlet var svLabelsY: UIStackView!
	@IBOutlet var lblStartX: UILabel!
	@IBOutlet var lblEndX: UILabel!
	
	var graphPoints = [4, 2, 6, 4, 5, 8, 3]
	
	override func draw(_ rect: CGRect) {
		
		let path = UIBezierPath(roundedRect: rect,
								byRoundingCorners: .allCorners,
								cornerRadii: Constants.cornerRadiusSize)
		path.addClip()

		let context = UIGraphicsGetCurrentContext()!
		let colors = [bgStartColor.cgColor, bgEndColor.cgColor]
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let colorLocations: [CGFloat] = [0.0, 1.0]
		let gradient = CGGradient(colorsSpace: colorSpace,
								  colors: colors as CFArray,
								  locations: colorLocations)!
		let startPoint = CGPoint.zero
		let endPoint = CGPoint(x: 0, y: bounds.height)
		context.drawLinearGradient(gradient,
								   start: startPoint,
								   end: endPoint,
								   options: [])
		
		let width = rect.width
		let height = rect.height
		
		// X Points
		let margin = Constants.margin
		let graphWidth = width - margin * 2 - 4
		let columnXPoint = { (column: Int) -> CGFloat in
			//Calculate the gap between points
			let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
			return CGFloat(column) * spacing + margin + 2
		}
		
		// Y Points
		let topBorder = Constants.topBorder
		let bottomBorder = Constants.bottomBorder
		let graphHeight = height - topBorder - bottomBorder
		let maxValue = graphPoints.max()!
		let columnYPoint = { (graphPoint: Int) -> CGFloat in
			let y = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
			return graphHeight + topBorder - y
		}
		
		// draw the line graph
		
		UIColor.white.setFill()
		UIColor.white.setStroke()
		
		let graphPath = UIBezierPath()
		graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
		for i in 1..<graphPoints.count {
			let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
			graphPath.addLine(to: nextPoint)
		}
		
		//Create the clipping path for the graph gradient
		
		context.saveGState()
		let clippingPath = graphPath.copy() as! UIBezierPath
		clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1), y:height))
		clippingPath.addLine(to: CGPoint(x:columnXPoint(0), y:height))
		clippingPath.close()
		clippingPath.addClip()
		
		let highestYPoint = columnYPoint(maxValue)
		let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
		let graphEndPoint = CGPoint(x: margin, y: bounds.height)
		
		context.drawLinearGradient(gradient, start: graphStartPoint, end: graphEndPoint, options: [])
		context.restoreGState()
		
		//draw the line on top of the clipped gradient
		graphPath.lineWidth = 2.0
		graphPath.stroke()
		
		//Draw the circles on top of the graph stroke
		for i in 0..<graphPoints.count {
			var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
			point.x -= Constants.circleDiameter / 2
			point.y -= Constants.circleDiameter / 2
			
			let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
			circle.fill()
		}
		
		//Draw horizontal graph lines on the top of everything
		let linePath = UIBezierPath()
		
		linePath.move(to: CGPoint(x: margin, y: topBorder))
		linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))
		linePath.move(to: CGPoint(x: margin, y: graphHeight/2 + topBorder))
		linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight/2 + topBorder))
		linePath.move(to: CGPoint(x: margin, y:height - bottomBorder))
		linePath.addLine(to: CGPoint(x:  width - margin, y: height - bottomBorder))
		let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
		color.setStroke()
		
		linePath.lineWidth = 1.0
		linePath.stroke()
	}
}
