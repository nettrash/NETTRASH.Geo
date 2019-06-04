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
        handler(nil)
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
		var template: CLKComplicationTemplate?
		switch complication.family {
		case .modularSmall:
			let modularSmallTemplate =
				CLKComplicationTemplateModularSmallRingText()
			modularSmallTemplate.textProvider =
				CLKSimpleTextProvider(text: "R")
			modularSmallTemplate.fillFraction = 0.75
			modularSmallTemplate.ringStyle = CLKComplicationRingStyle.closed
			template = modularSmallTemplate
		case .modularLarge:
			let modularLargeTemplate =
				CLKComplicationTemplateModularLargeStandardBody()
			modularLargeTemplate.headerTextProvider =
				CLKTimeIntervalTextProvider(start: NSDate() as Date,
											end: NSDate(timeIntervalSinceNow: 1 * 60 * 60) as Date)
			modularLargeTemplate.body1TextProvider =
				CLKSimpleTextProvider(text: "Movie Name",
									  shortText: "Movie")
			modularLargeTemplate.body2TextProvider =
				CLKSimpleTextProvider(text: "Running Time",
									  shortText: "Time")
			template = modularLargeTemplate
		case .circularSmall:
			template = nil
		case .extraLarge:
			template = nil
		case .graphicBezel:
			template = nil
		case .graphicCircular:
			template = nil
		case .graphicCorner:
			template = nil
		case .graphicRectangular:
			let graphicRectangularTemplate =
				CLKComplicationTemplateUtilitarianLargeFlat()
			graphicRectangularTemplate.textProvider =
				CLKSimpleTextProvider(text: "R")
			template = graphicRectangularTemplate
		case .utilitarianLarge:
			let utilitarianLargeTemplate =
				CLKComplicationTemplateUtilitarianLargeFlat()
			utilitarianLargeTemplate.textProvider =
				CLKSimpleTextProvider(text: "R")
			template = utilitarianLargeTemplate
		case .utilitarianSmall:
			let utilitarianSmallTemplate =
				CLKComplicationTemplateUtilitarianSmallRingText()
			utilitarianSmallTemplate.textProvider =
				CLKSimpleTextProvider(text: "R")
			utilitarianSmallTemplate.fillFraction = 0.75
			utilitarianSmallTemplate.ringStyle = CLKComplicationRingStyle.closed
			template = utilitarianSmallTemplate
		case .utilitarianSmallFlat:
			let utilitarianSmallFlatTemplate =
				CLKComplicationTemplateUtilitarianSmallFlat()
			utilitarianSmallFlatTemplate.textProvider =
				CLKSimpleTextProvider(text: "R")
			template = utilitarianSmallFlatTemplate
		}
		handler(template)
	}
    
}
