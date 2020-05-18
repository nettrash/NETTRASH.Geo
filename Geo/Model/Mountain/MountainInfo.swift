//
//  MountainBase.swift
//  Geo
//
//  Created by Иван Алексеев on 18.05.2020.
//  Copyright © 2020 NETTRASH. All rights reserved.
//

import Foundation

class MountainInfo: Codable {
	
	var position: Int? = nil
	var image: String? = nil
	var partOfTheWorld: String? = nil
	var name: String? = nil
	var height: Int? = nil
	var location: String? = nil
	var country: String? = nil
	var coordinates: MountainCoordinates? = nil
	var relativeHeight: Int? = nil
	var parent: String? = nil
	var firstAscent: String? = nil
	var ascents: Int? = nil
	var attemptsToAscend: Int? = nil

}
