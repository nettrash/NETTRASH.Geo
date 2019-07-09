//
//  InterfaceController.swift
//  Geo WatchKit Extension
//
//  Created by Иван Алексеев on 13/05/2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

	private let barWidthMax: CGFloat = 100
	
	@IBOutlet var lblAltitudeInfo: WKInterfaceLabel!
	@IBOutlet var imgEverestBar: WKInterfaceImage!
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
		let ext: ExtensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate
		ext.bar.dataUpdated = barometerDataUpdate
		
		drawEverestBar(0, UIColor.green)
	}
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	
	func barometerDataUpdate() {
		let ext: ExtensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate
		
		let everestPercent: CGFloat = 100.0 * CGFloat(ext.bar.everest)
		let width = CGFloat(everestPercent * barWidthMax / 100.0)
		let colorDelta = everestPercent * 255.0 / 100.0
		let everestPercentText = String(format: "%.4f", everestPercent)
		let everestColor = UIColor(red: CGFloat(colorDelta / 255.0), green: CGFloat((255.0 - colorDelta) / 255.0), blue: 0, alpha: 1)

		drawEverestBar(width, everestColor)
		
		self.lblAltitudeInfo.setText(String(format: NSLocalizedString("%.0f m\n%.0f mm Hg\n%@ %%🏔", comment: ""), ext.bar.height, ext.bar.pressure * 7.50062, everestPercentText))
		ext.refreshComplication()
		ext.traceBarometer()
	}

	func drawEverestBar(_ width: CGFloat, _ color: UIColor)
	{
		let context = createContext()
		
		drawLine( context, startX: 1, startY: 0, endX: barWidthMax-1, endY: 0, color: UIColor.lightGray )
		drawLine( context, startX: 0.7, startY: 1, endX: barWidthMax-0.7, endY: 1, color: UIColor.lightGray )
		drawLine( context, startX: 0.4, startY: 2, endX: barWidthMax-0.4, endY: 2, color: UIColor.gray )
		drawLine( context, startX: 0, startY: 3, endX: barWidthMax, endY: 3, color: UIColor.darkGray )
		drawLine( context, startX: 0, startY: 4, endX: barWidthMax, endY: 4, color: UIColor.darkGray )
		drawLine( context, startX: 0.4, startY: 5, endX: barWidthMax-0.4, endY: 5, color: UIColor.gray )
		drawLine( context, startX: 0.7, startY: 6, endX: barWidthMax-0.7, endY: 6, color: UIColor.lightGray )
		drawLine( context, startX: 1, startY: 7, endX: barWidthMax-1, endY: 7, color: UIColor.lightGray )

		drawLine( context, startX: 1, startY: 0, endX: width > 3 ? width-1 : width, endY: 0, color: color )
		drawLine( context, startX: 0.7, startY: 1, endX: width > 3 ? width-0.7 : width, endY: 1, color: color )
		drawLine( context, startX: 0.4, startY: 2, endX: width > 3 ? width-0.4 : width, endY: 2, color: color )
		drawLine( context, startX: 0, startY: 3, endX: width, endY: 3, color: color )
		drawLine( context, startX: 0, startY: 4, endX: width, endY: 4, color: color )
		drawLine( context, startX: 0.4, startY: 5, endX: width > 3 ? width-0.4 : width, endY: 5, color: color )
		drawLine( context, startX: 0.7, startY: 6, endX: width > 3 ? width-0.7 : width, endY: 6, color: color )
		drawLine( context, startX: 1, startY: 7, endX: width > 3 ? width-1 : width, endY: 7, color: color )
		//drawCircle( context, radius : 2, centreX : 1, centreY : 1, color: color )
		
		applyContextToImage( context )
	}
	
	func createContext() -> CGContext?
	{
		UIGraphicsBeginImageContextWithOptions(CGSize(width: barWidthMax, height: 8 ), false, 0)
		let context = UIGraphicsGetCurrentContext()
		context!.beginPath()
		
		return context
	}
	
	func drawLine( _ context: CGContext?, startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat, color: UIColor )
	{
		context!.setStrokeColor(color.cgColor)
		context!.setLineWidth(1.0)
		context!.move(to: CGPoint(x: startX, y: startY))
		context!.addLine(to: CGPoint(x: endX, y: endY))
		context!.strokePath()
	}
	
	func drawCircle( _ context: CGContext?, radius: CGFloat, centreX: CGFloat, centreY: CGFloat, color: UIColor )
	{
		let diameter = radius * 2.0
		let rect = CGRect( x: centreX - radius, y : centreY - radius, width : diameter, height : diameter )
		
		context!.setLineWidth( 1.0 )
		context!.setStrokeColor( color.cgColor )
		context!.strokeEllipse(in: rect)
	}
	
	func applyContextToImage( _ context : CGContext? )
	{
		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		imgEverestBar.setImage( img )
	}
}
