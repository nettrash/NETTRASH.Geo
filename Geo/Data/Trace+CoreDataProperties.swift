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

	@nonobjc public class func weekAggregateFetchRequest(_ nMaxCount: Int) -> NSFetchRequest<NSFetchRequestResult> {
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
		request.fetchLimit = nMaxCount
		let sortDay = NSSortDescriptor(key: "day", ascending: false)
		request.sortDescriptors = [sortDay]
		return request
	}
	
	@nonobjc public class func mapRouteFetchRequest(count: Int? = nil) -> NSFetchRequest<NSFetchRequestResult> {
		
		let keypathExpAltitudeBar = NSExpression(forKeyPath: "altitudeBAR")
		let expressionMaxAltitudeBAR = NSExpression(forFunction: "max:", arguments: [keypathExpAltitudeBar])
		
		let descMaxAltitudeBar = NSExpressionDescription()
		descMaxAltitudeBar.expression = expressionMaxAltitudeBAR
		descMaxAltitudeBar.name = "altitudeBAR"
		descMaxAltitudeBar.expressionResultType = .doubleAttributeType

		let keypathExpAltitudeGps = NSExpression(forKeyPath: "altitudeGPS")
		let expressionMaxAltitudeGPS = NSExpression(forFunction: "max:", arguments: [keypathExpAltitudeGps])
		
		let descMaxAltitudeGps = NSExpressionDescription()
		descMaxAltitudeGps.expression = expressionMaxAltitudeGPS
		descMaxAltitudeGps.name = "altitudeGPS"
		descMaxAltitudeGps.expressionResultType = .doubleAttributeType

		let keypathExpPressure = NSExpression(forKeyPath: "pressure")
		let expressionMinPressure = NSExpression(forFunction: "min:", arguments: [keypathExpPressure])
		
		let descMinPressure = NSExpressionDescription()
		descMinPressure.expression = expressionMinPressure
		descMinPressure.name = "pressure"
		descMinPressure.expressionResultType = .doubleAttributeType

		let keypathExpEverest = NSExpression(forKeyPath: "everest")
		let expressionMaxEverest = NSExpression(forFunction: "max:", arguments: [keypathExpEverest])
		
		let descMaxEverest = NSExpressionDescription()
		descMaxEverest.expression = expressionMaxEverest
		descMaxEverest.name = "everest"
		descMaxEverest.expressionResultType = .doubleAttributeType

		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trace")
		request.returnsObjectsAsFaults = false
		request.propertiesToFetch = ["date", "latitude", "longitude", descMinPressure, descMaxAltitudeBar, descMaxEverest, descMaxAltitudeGps]
		let sortDate = NSSortDescriptor(key: "date", ascending: false)
		request.sortDescriptors = [sortDate]
		request.propertiesToGroupBy = ["date", "latitude", "longitude"]
		request.resultType = .dictionaryResultType
		if count != nil {
			request.fetchLimit = count!
		}
		return request
	}

	@nonobjc public class func lastTraceFetchRequest() -> NSFetchRequest<Trace> {
		let request = NSFetchRequest<Trace>(entityName: "Trace")
		request.returnsObjectsAsFaults = false
		request.fetchLimit = 1
		let sortDate = NSSortDescriptor(key: "date", ascending: false)
		request.sortDescriptors = [sortDate]
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
