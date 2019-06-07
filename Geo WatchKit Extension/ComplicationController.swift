//
//  ComplicationController.swift
//  Geo WatchKit Extension
//
//  Created by Иван Алексеев on 13/05/2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//

import ClockKit
import WatchKit

class ComplicationController: NSObject, CLKComplicationDataSource {
	
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    /*
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
		handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
*/
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
		return handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: getData(complication)))
    }
/*
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
		return handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
		return handler(nil)
    }
   */
    // MARK: - Placeholder Templates
	
	func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
		return handler(getTemplate(complication))
	}
	
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
		return handler(getTemplate(complication))
	}
	
	// MARK: - Update Scheduling
	
	func getNextRequestedUpdateDateWithHandler(handler: (Date?) -> Void) {
		// Call the handler with the date when you would next like to be given the opportunity to update your complication content
		let next = Date(timeIntervalSinceNow: 60);
		handler(next)
	}

	// MAIN FUNCTION
	
	private func getData(_ complication: CLKComplication) -> CLKComplicationTemplate {
		let ext: ExtensionDelegate? = WKExtension.shared().delegate as? ExtensionDelegate
		
		let heightText = String(format: "%.0f", ext?.bar.height ?? 0)
		let pressureText = String(format: "%.0f", (ext?.bar.pressure ?? 0) * 7.50062)
		let everest: Float = Float(ext?.bar.everest ?? 0)
		let heightUnitText = "m"
		
		let everestPercent = 100.0 * everest
		let colorDelta = everestPercent * 255.0 / 100.0
		
		let everestColor = UIColor(red: CGFloat(colorDelta / 255.0), green: CGFloat((255.0 - colorDelta) / 255.0), blue: 0, alpha: 1)
		
		var template: CLKComplicationTemplate?
		switch complication.family {
		case .graphicCircular:
			let graphicCircularTemplate =
				CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText()
			graphicCircularTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.fill, gaugeColor: everestColor, 	fillFraction: everest)
			graphicCircularTemplate.centerTextProvider = CLKSimpleTextProvider(text: heightText)
			graphicCircularTemplate.bottomTextProvider = CLKSimpleTextProvider(text: heightUnitText)
			template = graphicCircularTemplate
		default:
			let defaultTemplate =
				CLKComplicationTemplateModularSmallStackText()
			defaultTemplate.line1TextProvider = CLKSimpleTextProvider(text: heightText)
			defaultTemplate.line2TextProvider = CLKSimpleTextProvider(text: pressureText)
			template = defaultTemplate
		}
		return template!
	}
	
	private func getTemplate(_ complication: CLKComplication) -> CLKComplicationTemplate {
		
		let heightText = "----"
		let pressureText = "---"
		let everest: Float = 0
		let heightUnitText = "m"
		
		var template: CLKComplicationTemplate?
		switch complication.family {
		case .graphicCircular:
			let graphicCircularTemplate =
				CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText()
			graphicCircularTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.fill, gaugeColor: UIColor.green, 	fillFraction: everest)
			graphicCircularTemplate.centerTextProvider = CLKSimpleTextProvider(text: heightText)
			graphicCircularTemplate.bottomTextProvider = CLKSimpleTextProvider(text: heightUnitText)
			template = graphicCircularTemplate
		default:
			let defaultTemplate =
				CLKComplicationTemplateModularSmallStackText()
			defaultTemplate.line1TextProvider = CLKSimpleTextProvider(text: heightText)
			defaultTemplate.line2TextProvider = CLKSimpleTextProvider(text: pressureText)
			template = defaultTemplate
		}
		return template!
	}
}
