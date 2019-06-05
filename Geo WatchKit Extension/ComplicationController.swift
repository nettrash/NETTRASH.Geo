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
	
	let ext: ExtensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate
	
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
		handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
		return handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: getTemplate(complication)))
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
		handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
		handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
		return handler(getTemplate(complication))
	}
	
	// MAIN FUNCTION
	
	private func getTemplate(_ complication: CLKComplication) -> CLKComplicationTemplate {
		let heightText = String(format: "%.0f", ext.bar.height)
		let pressureText = String(format: "%.0f", ext.bar.pressure * 7.50062)
		let everest: Float = Float(ext.bar.height / 8848)
		let heightUnitText = "m"
		
		var template: CLKComplicationTemplate?
		switch complication.family {
		case .modularSmall:
			let modularSmallTemplate =
				CLKComplicationTemplateModularSmallRingText()
			modularSmallTemplate.textProvider =
				CLKSimpleTextProvider(text: heightText)
			modularSmallTemplate.fillFraction = everest
			modularSmallTemplate.ringStyle = CLKComplicationRingStyle.closed
			template = modularSmallTemplate
		case .modularLarge:
			let modularLargeTemplate =
				CLKComplicationTemplateModularLargeStandardBody()
			modularLargeTemplate.headerTextProvider =
				CLKTimeIntervalTextProvider(start: NSDate() as Date,
											end: NSDate(timeIntervalSinceNow: 1 * 60 * 60) as Date)
			modularLargeTemplate.body1TextProvider =
				CLKSimpleTextProvider(text: heightText,
									  shortText: heightText)
			modularLargeTemplate.body2TextProvider =
				CLKSimpleTextProvider(text: pressureText,
									  shortText: pressureText)
			template = modularLargeTemplate
		case .circularSmall:
			let circularSmallTemplate =
				CLKComplicationTemplateCircularSmallRingText()
			circularSmallTemplate.textProvider =
				CLKSimpleTextProvider(text: heightText)
			circularSmallTemplate.fillFraction = everest
			circularSmallTemplate.ringStyle = CLKComplicationRingStyle.closed
			template = circularSmallTemplate
		case .extraLarge:
			let extraLargeTemplate =
				CLKComplicationTemplateExtraLargeSimpleText()
			extraLargeTemplate.textProvider =
				CLKSimpleTextProvider(text: heightText)
			template = extraLargeTemplate
		case .graphicBezel:
			let graphicBezelTemplate =
				CLKComplicationTemplateGraphicBezelCircularText()
			graphicBezelTemplate.textProvider = CLKSimpleTextProvider(text: heightText)
			template = graphicBezelTemplate
		case .graphicCircular:
			let graphicCircularTemplate =
				CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText()
			graphicCircularTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.ring, gaugeColor: UIColor.green, fillFraction: everest)
			graphicCircularTemplate.centerTextProvider = CLKSimpleTextProvider(text: heightText)
			graphicCircularTemplate.bottomTextProvider = CLKSimpleTextProvider(text: heightUnitText)
			template = graphicCircularTemplate
		case .graphicCorner:
			let graphicCornerTemplate =
				CLKComplicationTemplateGraphicCornerGaugeText()
			graphicCornerTemplate.outerTextProvider = CLKSimpleTextProvider(text: heightText)
			graphicCornerTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.ring, gaugeColor: UIColor.green, fillFraction: everest)
			template = graphicCornerTemplate
		case .graphicRectangular:
			let graphicRectangularTemplate =
				CLKComplicationTemplateGraphicRectangularTextGauge()
			graphicRectangularTemplate.headerTextProvider =
				CLKSimpleTextProvider(text: pressureText)
			graphicRectangularTemplate.body1TextProvider =
				CLKSimpleTextProvider(text: heightText)
			graphicRectangularTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.ring, gaugeColor: UIColor.green, fillFraction: everest)
			template = graphicRectangularTemplate
		case .utilitarianLarge:
			let utilitarianLargeTemplate =
				CLKComplicationTemplateUtilitarianLargeFlat()
			utilitarianLargeTemplate.textProvider =
				CLKSimpleTextProvider(text: heightText)
			template = utilitarianLargeTemplate
		case .utilitarianSmall:
			let utilitarianSmallTemplate =
				CLKComplicationTemplateUtilitarianSmallRingText()
			utilitarianSmallTemplate.textProvider =
				CLKSimpleTextProvider(text: heightText)
			utilitarianSmallTemplate.fillFraction = everest
			utilitarianSmallTemplate.ringStyle = CLKComplicationRingStyle.closed
			template = utilitarianSmallTemplate
		case .utilitarianSmallFlat:
			let utilitarianSmallFlatTemplate =
				CLKComplicationTemplateUtilitarianSmallFlat()
			utilitarianSmallFlatTemplate.textProvider =
				CLKSimpleTextProvider(text: heightText)
			template = utilitarianSmallFlatTemplate
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
