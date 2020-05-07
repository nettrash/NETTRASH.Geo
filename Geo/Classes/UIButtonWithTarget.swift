//
//  UIButtonWithTarget.swift
//  Geo
//
//  Created by Иван Алексеев on 07.05.2020.
//  Copyright © 2020 NETTRASH. All rights reserved.
//

import Foundation
import UIKit

class UIButtonWithTarget : UIButton {
	
	internal var target: Any?
	
	func setTarget(_ trgt: Any?) {
		target = trgt
	}
	
	func getTarget() -> Any? {
		return target
	}
}
