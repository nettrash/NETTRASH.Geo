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

	@IBOutlet var lblAltitudeInfo: WKInterfaceLabel!
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
		let ext: ExtensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate
		ext.bar.dataUpdated = barometerDataUpdate
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
		
		let everestPercent = 100.0 * ext.bar.everest
		let colorDelta = everestPercent * 255.0 / 100.0
		let everestPercentText = String(format: "%.4f", everestPercent)
		let everestColor = UIColor(red: CGFloat(colorDelta / 255.0), green: CGFloat((255.0 - colorDelta) / 255.0), blue: 0, alpha: 1)

		self.lblAltitudeInfo.setText(String(format: "%.0f m\n%.0f mm Hg\n%@ %%🏔", ext.bar.height, ext.bar.pressure * 7.50062, everestPercentText))
		ext.refreshComplication()
	}

}
