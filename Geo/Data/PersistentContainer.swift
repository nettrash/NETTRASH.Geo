//
//  PersistentContainer.swift
//  Geo
//
//  Created by Иван Алексеев on 09/07/2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//

import Foundation
import CoreData

class PersistentContainer: NSPersistentContainer {
	override class func defaultDirectoryURL() -> URL{
		return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ru.nettrash.geo")!
	}
}
