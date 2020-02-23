//
//  Mark+CoreDataProperties.swift
//  Geo
//
//  Created by Иван Алексеев on 23.02.2020.
//  Copyright © 2020 NETTRASH. All rights reserved.
//

import Foundation
import CoreData

extension Mark {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<Mark> {
		return NSFetchRequest<Mark>(entityName: "Mark")
	}

	@NSManaged public var name: String
	@NSManaged public var message: String
	@NSManaged public var date: NSDate?
	@NSManaged public var day: NSDate?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var pressure: Double
    @NSManaged public var altitudeBAR: Double
    @NSManaged public var everest: Double
    @NSManaged public var altitudeGPS: Double
	
}
