//
//  OpenWeatherMapResponse.swift
//  Geo
//
//  Created by Иван Алексеев on 13/06/2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//

import Foundation

/*
Parameters:

coord
	coord.lon City geo location, longitude
	coord.lat City geo location, latitude
weather (more info Weather condition codes)
	weather.id Weather condition id
	weather.main Group of weather parameters (Rain, Snow, Extreme etc.)
	weather.description Weather condition within the group
	weather.icon Weather icon id
base Internal parameter
main
	main.temp Temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
	main.pressure Atmospheric pressure (on the sea level, if there is no sea_level or grnd_level data), hPa
	main.humidity Humidity, %
	main.temp_min Minimum temperature at the moment. This is deviation from current temp that is possible for large cities and megalopolises geographically expanded (use these parameter optionally). Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
	main.temp_max Maximum temperature at the moment. This is deviation from current temp that is possible for large cities and megalopolises geographically expanded (use these parameter optionally). Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
	main.sea_level Atmospheric pressure on the sea level, hPa
	main.grnd_level Atmospheric pressure on the ground level, hPa
wind
	wind.speed Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
	wind.deg Wind direction, degrees (meteorological)
clouds
	clouds.all Cloudiness, %
rain
	rain.1h Rain volume for the last 1 hour, mm
	rain.3h Rain volume for the last 3 hours, mm
snow
	snow.1h Snow volume for the last 1 hour, mm
	snow.3h Snow volume for the last 3 hours, mm
dt Time of data calculation, unix, UTC
sys
	sys.type Internal parameter
	sys.id Internal parameter
	sys.message Internal parameter
	sys.country Country code (GB, JP etc.)
	sys.sunrise Sunrise time, unix, UTC
	sys.sunset Sunset time, unix, UTC
id City ID
name City name
cod Internal parameter
*/

class OpenWeatherMapResponse : Decodable {
	let coord: OpenWeatherMapCoord?
	let weather: [OpenWeatherMapItem]?
	let base: String?
	let main: OpenWeatherMapMain?
	let visibility: Int64?
	let wind: OpenWeatherMapWind?
	let clouds: OpenWeatherMapClouds?
	let rain: OpenWeatherMapRain?
	let snow: OpenWeatherMapSnow?
	let dt: Int64?
	let sys: OpenWeatherMapSystem?
	let id: Int64?
	let name: String?
	let cod: Int64?
	
	var weatherDetails: String? {
		get {
			var values: [String] = []
			
			if main?.temp != nil {
				values.append(String(format:NSLocalizedString("Temperature %.1f C", comment: ""), main!.temp!-273.15))
			}
			if main?.humidity != nil {
				values.append(String(format: NSLocalizedString("Humidity %i %%", comment: ""), main!.humidity!))
			}
			if visibility != nil {
				values.append(String(format:NSLocalizedString("Visibility %i m", comment: ""), visibility!))
			}
			if wind?.speed != nil {
				values.append(String(format:NSLocalizedString("Wind speed %.1f m/s", comment: ""), wind!.speed!))
			}
			
			return values.joined(separator: "\n")
		}
	}
	
	var weatherDetailsTemperature: String? {
		get {
			return String(format:NSLocalizedString("Temperature: %.1f C", comment: ""), main!.temp!-273.15)
		}
	}
	
	var weatherDetailsHumidity: String? {
		get {
			return String(format: NSLocalizedString("Humidity: %i %%", comment: ""), main!.humidity!)
		}
	}
	
	var weatherDetailsVisibility: String? {
		get {
			return String(format:NSLocalizedString("Visibility: %i m", comment: ""), visibility!)
		}
	}
	
	var weatherDetailsWindSpeed: String? {
		get {
			return String(format:NSLocalizedString("Wind speed: %.1f m/s", comment: ""), wind!.speed!)
		}
	}
	
	var weatherDetailsWindDirection: String? {
		get {
			return String(format:NSLocalizedString("Wind direction: %s (%.1f deg)", comment: ""), wind!.getDirection()!, wind!.deg!)
		}
	}
}

class OpenWeatherMapSystem : Decodable {
	let type: Int64?
	let id: Int64?
	let message: Double?
	let country: String?
	let sunrise: Int64?
	let sunset: Int64?
}

class OpenWeatherMapRain : Decodable {
	let hour: Int64?
	let threeHour: Int64?
	
	enum CodingKeys: String, CodingKey {
		case hour = "1h"
		case threeHour = "3h"
	}
}

class OpenWeatherMapSnow : Decodable {
	let hour: Int64?
	let threeHour: Int64?
	
	enum CodingKeys: String, CodingKey {
		case hour = "1h"
		case threeHour = "3h"
	}
}

class OpenWeatherMapClouds : Decodable {
	let all: Int64?
}

class OpenWeatherMapWind : Decodable {
	let speed: Double?
	let deg: Int64?
	
	func getDirection() -> String? {
		guard let degree = deg else {
			return ""
		}
		switch degree % 360 {
		case 355...360, 0...5:
			return NSLocalizedString("Nord", comment: "")
		case 85...95:
			return NSLocalizedString("East", comment: "")
		case 175...185:
			return NSLocalizedString("South", comment: "")
		case 265...275:
			return NSLocalizedString("West", comment: "")
		case 276...354:
			return NSLocalizedString("NordWest", comment: "")
		case 6...84:
			return NSLocalizedString("NordEast", comment: "")
		case 96...174:
			return NSLocalizedString("SouthEast", comment: "")
		case 186...264:
			return NSLocalizedString("SouthWest", comment: "")
		default:
			return ""
		}
	}
}

class OpenWeatherMapMain : Decodable {
	let temp: Double?
	let pressure: Int64?
	let humidity: Int64?
	let temp_min: Double?
	let temp_max: Double?
	let sea_level: Double?
	let grnd_level: Double?
}

class OpenWeatherMapItem : Decodable {
	let id: Int64?
	let main: String?
	let description: String?
	let icon: String?
}

class OpenWeatherMapCoord : Decodable {
	let lon: Double?
	let lat: Double?
}

/*
{
	"coord":{"lon":145.77,"lat":-16.92},
	"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04n"}],
	"base":"cmc stations",
	"main":{"temp":293.25,"pressure":1019,"humidity":83,"temp_min":289.82,"temp_max":295.37},
	"wind":{"speed":5.1,"deg":150},
	"clouds":{"all":75},
	"rain":{"3h":3},
	"dt":1435658272,
	"sys":{"type":1,"id":8166,"message":0.0166,"country":"AU","sunrise":1435610796,"sunset":1435650870},
	"id":2172797,
	"name":"Cairns",
	"cod":200}

}
*/
