//
//  Weather.swift
//  Geo
//
//  Created by Иван Алексеев on 13/06/2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//

import Foundation
import CoreLocation

class Weather {
	
	enum WeatherAPI {
		case OpenWeatherMap
	}
	
	var apiResponse: String?
	
	private func _requestOpenWeather(_ coord: CLLocation) -> String? {
		if let url = URL(string: String(format:"https://api.openweathermap.org/data/2.5/weather?lat=%.2f&lon=%.2f&APPID=a69d7d8a999f17496013dc1c3f61baaf", coord.coordinate.latitude, coord.coordinate.longitude)) {
			return try? String(contentsOf: url, encoding: String.Encoding.utf8)
		}
		return nil
	}
	
	func Get(api: WeatherAPI, coordinate: CLLocation) -> Any? {
		var response: String? = nil
		var retVal: Any? = nil
		
		let decoder = JSONDecoder()
		
		switch api {
		case .OpenWeatherMap:
			response = _requestOpenWeather(coordinate)
			if response != nil {
				retVal = try? decoder.decode(OpenWeatherMapResponse.self, from: (response?.data(using: String.Encoding.utf8))!)
			}
		}
		
		apiResponse = response
		return retVal
	}
}
