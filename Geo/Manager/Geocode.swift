//
//  Geocode.swift
//  Geo
//
//  Created by Иван Алексеев on 29/05/2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//

import Foundation
import CoreLocation

//https://geocode-maps.yandex.ru/1.x
//? geocode=<string>
//& apikey=<string>
//& [sco=<string>]
//& [kind=<string>]
//& [rspn=<boolean>]
//& [ll=<number>, <number>]
//& [spn=<number>, <number>]
//& [bbox=<number>,<number>~<number>,<number>]
//& [format=<string>]
//& [skip=<integer>]
//& [lang=<string>]
//& [callback=<string>]

class Geocode {
	
	private var geocode: String
	private let apikey: String = "6bdf94fd-fe8d-495b-86ee-053f9d68a56c"
	private var sco: String
	private let kind: String = "district"
	private let format: String = "json"
	private let lang: String = "en_US"//"ru_RU"
	private var YandexURL: URL?
	
	var Data: String?
	var Response: YandexResponse?
	
	init(_ location: CLLocation) {
		geocode = String(format:"%.6f,%.6f", location.coordinate.longitude, location.coordinate.latitude)
		sco = "longlat"
		YandexURL = URL(string: "https://geocode-maps.yandex.ru/1.x?apikey=\(apikey)&lang=\(lang)&format=\(format)&kind=\(kind)&sco=\(sco)&geocode=\(geocode)&results=1")
		
		Data = try? String(contentsOf: YandexURL!, encoding: String.Encoding.utf8)
		Response = nil
		parseData()
	}
	
	init(_ address: String) {
		geocode = address
		sco = ""
		YandexURL = URL(string: "https://geocode-maps.yandex.ru/1.x?apikey=\(apikey)&lang=\(lang)&format=\(format)&kind=\(kind)&geocode=\(geocode)&results=1")
		
		Data = try? String(contentsOf: YandexURL!, encoding: String.Encoding.utf8)
		Response = nil
		parseData()
	}
	
	private func parseData() {
		if self.Data == nil { return }
		
		let decoder = JSONDecoder()
		Response = try? decoder.decode(YandexResponse.self, from: (self.Data?.data(using: String.Encoding.utf8))!)
	}
}
