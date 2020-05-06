//
//  UIButton.swift
//  Geo
//
//  Created by Иван Алексеев on 06.05.2020.
//  Copyright © 2020 NETTRASH. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
	
	func roundCorners(radius: Int) {
		let maskPath = UIBezierPath(roundedRect: bounds,
									byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
									cornerRadii: CGSize(width: radius, height: radius))
		let maskLayer = CAShapeLayer()
		maskLayer.frame = bounds
		maskLayer.path = maskPath.cgPath
		layer.mask = maskLayer
	}
}
