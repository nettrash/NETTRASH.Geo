//
//  Trace+CoreDataProperties.swift
//  Geo
//
//  Created by Иван Алексеев on 09/07/2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//
//

import Foundation
import CoreData


extension Trace {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<Trace> {
		return NSFetchRequest<Trace>(entityName: "Trace")
	}

	@nonobjc public class func weekAggregateFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
		let keypathExpAltitudeBar = NSExpression(forKeyPath: "altitudeBAR")
		let expressionMaxAltitudeBAR = NSExpression(forFunction: "max:", arguments: [keypathExpAltitudeBar])
		
		let descMaxAltitudeBar = NSExpressionDescription()
		descMaxAltitudeBar.expression = expressionMaxAltitudeBAR
		descMaxAltitudeBar.name = "maxAltitudeBAR"
		descMaxAltitudeBar.expressionResultType = .doubleAttributeType

		let keypathExpPressure = NSExpression(forKeyPath: "pressure")
		let expressionMinPressure = NSExpression(forFunction: "min:", arguments: [keypathExpPressure])
		
		let descMinPressure = NSExpressionDescription()
		descMinPressure.expression = expressionMinPressure
		descMinPressure.name = "minPressure"
		descMinPressure.expressionResultType = .doubleAttributeType

		let keypathExpEverest = NSExpression(forKeyPath: "everest")
		let expressionMaxEverest = NSExpression(forFunction: "max:", arguments: [keypathExpEverest])
		
		let descMaxEverest = NSExpressionDescription()
		descMaxEverest.expression = expressionMaxEverest
		descMaxEverest.name = "maxEverest"
		descMaxEverest.expressionResultType = .doubleAttributeType

		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trace")
		request.returnsObjectsAsFaults = false
		request.propertiesToGroupBy = ["day"]
		request.propertiesToFetch = ["day", descMaxAltitudeBar, descMinPressure, descMaxEverest]
		request.resultType = .dictionaryResultType
		return request
	}

	@NSManaged public var date: NSDate?
	@NSManaged public var day: NSDate?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var pressure: Double
    @NSManaged public var altitudeBAR: Double
    @NSManaged public var everest: Double
    @NSManaged public var altitudeGPS: Double
}
