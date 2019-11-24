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
		
		let h = ext?.bar.height ?? 0
		var heightText = (h > 1000 ? String(format: "%.1fk", h/1000.0) : String(format: "%.0f", h))
		let pressureText = String(format: "%.0f", (ext?.bar.pressure ?? 0) * 7.50062)
		let everest: Float = Float(ext?.bar.everest ?? 0)
		let heightUnitText = NSLocalizedString("m", comment: "")
		let pressureUnitText = NSLocalizedString("mm Hg", comment: "")
		let everestUnitText = NSLocalizedString("% 🏔", comment: "")

		if ext == nil {
			heightText = "--"
			WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date(timeIntervalSinceNow: 5), userInfo: nil) { (_ error: Error?) in
				NSLog(error.debugDescription)
			}
		} else if ext!.bar.height < 1 {
			ext!.bar.Start()
			WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date(timeIntervalSinceNow: 5), userInfo: nil) { (_ error: Error?) in
				NSLog(error.debugDescription)
			}
		}
		
		let everestPercent = 100.0 * everest
		let colorDelta = everestPercent * 255.0 / 100.0
		let everestPercentText = String(format: "%.4f", everestPercent)
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
		case .graphicCorner:
			let graphicCornerTemplate = CLKComplicationTemplateGraphicCornerGaugeText()
			graphicCornerTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.fill, gaugeColor: UIColor.green, 	fillFraction: everest)
			graphicCornerTemplate.outerTextProvider = CLKSimpleTextProvider(text: heightText)
			return graphicCornerTemplate
		case .modularSmall:
			let modularSmallTemplate = CLKComplicationTemplateModularSmallRingText()
			modularSmallTemplate.fillFraction = everest
			modularSmallTemplate.ringStyle = .open;
			modularSmallTemplate.textProvider = CLKSimpleTextProvider(text: heightText)
			return modularSmallTemplate
		case .modularLarge:
			let modularLargeTemplate = CLKComplicationTemplateModularLargeColumns()
			modularLargeTemplate.column2Alignment = CLKComplicationColumnAlignment.trailing
			modularLargeTemplate.row1Column2TextProvider = CLKSimpleTextProvider(text: heightUnitText)
			modularLargeTemplate.row1Column1TextProvider = CLKSimpleTextProvider(text: heightText)
			modularLargeTemplate.row2Column2TextProvider = CLKSimpleTextProvider(text: pressureUnitText)
			modularLargeTemplate.row2Column1TextProvider = CLKSimpleTextProvider(text: pressureText)
			modularLargeTemplate.row3Column2TextProvider = CLKSimpleTextProvider(text: everestUnitText)
			modularLargeTemplate.row3Column1TextProvider = CLKSimpleTextProvider(text: everestPercentText)
			return modularLargeTemplate
		case .circularSmall:
			let circularSmallTemplate = CLKComplicationTemplateCircularSmallRingText()
			circularSmallTemplate.fillFraction = everest
			circularSmallTemplate.ringStyle = .open;
			circularSmallTemplate.textProvider = CLKSimpleTextProvider(text: heightText)
			return circularSmallTemplate
		case .graphicRectangular:
			let graphicRectangularTemplate = CLKComplicationTemplateGraphicRectangularTextGauge()
			graphicRectangularTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.fill, gaugeColor: UIColor.green, 	fillFraction: everest)
			graphicRectangularTemplate.body1TextProvider = CLKSimpleTextProvider(text: heightText + " " + heightUnitText)
			graphicRectangularTemplate.headerTextProvider = CLKSimpleTextProvider(text: NSLocalizedString("Altitude", comment:""))
			return graphicRectangularTemplate
		case .graphicBezel:
			let graphicBezelTemplate = CLKComplicationTemplateGraphicBezelCircularText()
			let circular = CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText()
			circular.gaugeProvider = CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.fill, gaugeColor: UIColor.green, 	fillFraction: everest)
			circular.centerTextProvider = CLKSimpleTextProvider(text: heightText)
			circular.bottomTextProvider = CLKSimpleTextProvider(text: heightUnitText)
			graphicBezelTemplate.circularTemplate = circular
			graphicBezelTemplate.textProvider = CLKSimpleTextProvider(text: pressureText + " " + pressureUnitText + ", " + everestPercentText + " " + everestUnitText)
			return graphicBezelTemplate
		case .extraLarge:
			let extraLargeTemplate = CLKComplicationTemplateExtraLargeRingText()
			extraLargeTemplate.fillFraction = everest
			extraLargeTemplate.ringStyle = .open;
			extraLargeTemplate.textProvider = CLKSimpleTextProvider(text: heightText)
			return extraLargeTemplate
		case .utilitarianSmall:
			let utilitarianSmallTemplate = CLKComplicationTemplateUtilitarianSmallRingText()
			utilitarianSmallTemplate.fillFraction = everest
			utilitarianSmallTemplate.ringStyle = .open;
			utilitarianSmallTemplate.textProvider = CLKSimpleTextProvider(text: heightText)
			return utilitarianSmallTemplate
		case .utilitarianSmallFlat:
			let utilitarianSmallFlatTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
			utilitarianSmallFlatTemplate.textProvider = CLKSimpleTextProvider(text: heightText)
			return utilitarianSmallFlatTemplate
		case .utilitarianLarge:
			let utilitarianLargeTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
			utilitarianLargeTemplate.textProvider = CLKSimpleTextProvider(text: heightText)
			return utilitarianLargeTemplate
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
		let heightUnitText = NSLocalizedString("m", comment: "")
		let everestPercentText = "---"
		let pressureUnitText = NSLocalizedString("mm Hg", comment: "")
		let everestUnitText = NSLocalizedString("% 🏔", comment: "")
		
		var template: CLKComplicationTemplate?
		switch complication.family {
		case .graphicCircular:
			let graphicCircularTemplate =
				CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText()
			graphicCircularTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.fill, gaugeColor: UIColor.green, 	fillFraction: everest)
			graphicCircularTemplate.centerTextProvider = CLKSimpleTextProvider(text: heightText)
			graphicCircularTemplate.bottomTextProvider = CLKSimpleTextProvider(text: heightUnitText)
			template = graphicCircularTemplate
		case .graphicCorner:
			let graphicCornerTemplate = CLKComplicationTemplateGraphicCornerGaugeText()
			graphicCornerTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.fill, gaugeColor: UIColor.green, 	fillFraction: everest)
			graphicCornerTemplate.outerTextProvider = CLKSimpleTextProvider(text: heightText)
			return graphicCornerTemplate
		case .modularSmall:
			let modularSmallTemplate = CLKComplicationTemplateModularSmallRingText()
			modularSmallTemplate.fillFraction = everest
			modularSmallTemplate.ringStyle = .open;
			modularSmallTemplate.textProvider = CLKSimpleTextProvider(text: heightText)
			return modularSmallTemplate
		case .modularLarge:
			let modularLargeTemplate = CLKComplicationTemplateModularLargeColumns()
			modularLargeTemplate.column2Alignment = CLKComplicationColumnAlignment.trailing
			modularLargeTemplate.row1Column2TextProvider = CLKSimpleTextProvider(text: heightUnitText)
			modularLargeTemplate.row1Column1TextProvider = CLKSimpleTextProvider(text: heightText)
			modularLargeTemplate.row2Column2TextProvider = CLKSimpleTextProvider(text: pressureUnitText)
			modularLargeTemplate.row2Column1TextProvider = CLKSimpleTextProvider(text: pressureText)
			modularLargeTemplate.row3Column2TextProvider = CLKSimpleTextProvider(text: everestUnitText)
			modularLargeTemplate.row3Column1TextProvider = CLKSimpleTextProvider(text: everestPercentText)
			return modularLargeTemplate
		case .circularSmall:
			let circularSmallTemplate = CLKComplicationTemplateCircularSmallRingText()
			circularSmallTemplate.fillFraction = everest
			circularSmallTemplate.ringStyle = .open;
			circularSmallTemplate.textProvider = CLKSimpleTextProvider(text: heightText)
			return circularSmallTemplate
		case .graphicRectangular:
			let graphicRectangularTemplate = CLKComplicationTemplateGraphicRectangularTextGauge()
			graphicRectangularTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.fill, gaugeColor: UIColor.green, 	fillFraction: everest)
			graphicRectangularTemplate.body1TextProvider = CLKSimpleTextProvider(text: heightText + " " + heightUnitText)
			graphicRectangularTemplate.headerTextProvider = CLKSimpleTextProvider(text: NSLocalizedString("Altitude", comment: ""))
			return graphicRectangularTemplate
		case .graphicBezel:
			let graphicBezelTemplate = CLKComplicationTemplateGraphicBezelCircularText()
			let circular = CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText()
			circular.gaugeProvider = CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.fill, gaugeColor: UIColor.green, 	fillFraction: everest)
			circular.centerTextProvider = CLKSimpleTextProvider(text: heightText)
			circular.bottomTextProvider = CLKSimpleTextProvider(text: heightUnitText)
			graphicBezelTemplate.circularTemplate = circular
			graphicBezelTemplate.textProvider = CLKSimpleTextProvider(text: pressureText + " " + pressureUnitText + ", " + everestPercentText + " " + everestUnitText)
			return graphicBezelTemplate
		case .extraLarge:
			let extraLargeTemplate = CLKComplicationTemplateExtraLargeRingText()
			extraLargeTemplate.fillFraction = everest
			extraLargeTemplate.ringStyle = .open;
			extraLargeTemplate.textProvider = CLKSimpleTextProvider(text: heightText)
			return extraLargeTemplate
		case .utilitarianSmall:
			let utilitarianSmallTemplate = CLKComplicationTemplateUtilitarianSmallRingText()
			utilitarianSmallTemplate.fillFraction = everest
			utilitarianSmallTemplate.ringStyle = .open;
			utilitarianSmallTemplate.textProvider = CLKSimpleTextProvider(text: heightText)
			return utilitarianSmallTemplate
		case .utilitarianSmallFlat:
			let utilitarianSmallFlatTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
			utilitarianSmallFlatTemplate.textProvider = CLKSimpleTextProvider(text: heightText)
			return utilitarianSmallFlatTemplate
		case .utilitarianLarge:
			let utilitarianLargeTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
			utilitarianLargeTemplate.textProvider = CLKSimpleTextProvider(text: heightText)
			return utilitarianLargeTemplate
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
