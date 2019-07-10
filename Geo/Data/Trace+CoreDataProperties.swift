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
		let keypathExp = NSExpression(forKeyPath: "altitudeBAR")
		let expression = NSExpression(forFunction: "max:", arguments: [keypathExp])
		
		let maxDesc = NSExpressionDescription()
		maxDesc.expression = expression
		maxDesc.name = "max"
		maxDesc.expressionResultType = .doubleAttributeType
		
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trace")
		request.returnsObjectsAsFaults = false
		request.propertiesToGroupBy = ["day"]
		request.propertiesToFetch = ["day", maxDesc]
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
