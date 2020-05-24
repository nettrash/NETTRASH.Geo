//
//  MapSetupViewController.swift
//  Geo
//
//  Created by Иван Алексеев on 24.05.2020.
//  Copyright © 2020 NETTRASH. All rights reserved.
//

import Foundation
import UIKit

class MapSetupViewController : UIViewController {
	
	@IBOutlet weak var handleArea: UIView!
	@IBOutlet weak var switchPoints: UISwitch!
	@IBOutlet weak var switchMarkers: UISwitch!
	@IBOutlet weak var switchHighest: UISwitch!
	@IBOutlet weak var switchSevenPeaks: UISwitch!
	@IBOutlet weak var switchSnowLeopard: UISwitch!

	override func viewDidLoad() {
		super.viewDidLoad()
	}
}
