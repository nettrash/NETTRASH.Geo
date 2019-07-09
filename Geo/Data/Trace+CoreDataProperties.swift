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

    @NSManaged public var date: NSDate?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var pressure: Double
    @NSManaged public var altitudeBAR: Double
    @NSManaged public var everest: Double
    @NSManaged public var altitudeGPS: Double

}
