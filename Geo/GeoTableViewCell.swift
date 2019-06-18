//
//  GeoTableCellView.swift
//  Geo
//
//  Created by Иван Алексеев on 18/06/2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//

import Foundation
import UIKit

class GeoTableViewCell : UITableViewCell {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialize()
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		initialize()
	}
	
	func initialize() {
		backgroundColor = UIColor.clear
		textLabel?.textColor = UIColor.lightText
		textLabel?.font = textLabel?.font.withSize(12)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		self.accessoryType = .none
	}
}
