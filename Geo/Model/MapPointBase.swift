//
//  MapPointBase.swift
//  Geo
//
//  Created by Иван Алексеев on 19.05.2020.
//  Copyright © 2020 NETTRASH. All rights reserved.
//

import Foundation
import UIKit

open class MapPointBase: NSObject {
	
	open var identifier: String {
		get {
			return "MapPointBase"
		}
	}
	open var tintColor: UIColor {
		get {
			return .red
		}
	}
	open var iconImage: UIImage? {
		get {
			return nil
		}
	}
	
}
