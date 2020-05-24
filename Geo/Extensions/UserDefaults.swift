//
//  UserDefaults.swift
//  Geo
//
//  Created by Иван Алексеев on 24.05.2020.
//  Copyright © 2020 NETTRASH. All rights reserved.
//

import Foundation

extension UserDefaults {
	
    func contains(_ key: String) -> Bool {
        return object(forKey: key) != nil
    }
	
	func bool(forKey key: String, default value: Bool) -> Bool {
		if contains(key) {
			return bool(forKey: key)
		} else {
			return value
		}
	}
	
}
