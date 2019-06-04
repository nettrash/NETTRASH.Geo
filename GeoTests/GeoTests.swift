//
//  GeoTests.swift
//  GeoTests
//
//  Created by Иван Алексеев on 13/05/2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//

import XCTest
@testable import Geo

class GeoTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
	
	func testYandexGeocode() {
		let data: String = "{\"response\":{\"GeoObjectCollection\":{\"metaDataProperty\":{\"GeocoderResponseMetaData\":{\"request\":\"37.667710,55.732108\",\"found\":\"2\",\"results\":\"1\",\"Point\":{\"pos\":\"37.667710 55.732108\"},\"kind\":\"district\"}},\"featureMember\":[{\"GeoObject\":{\"metaDataProperty\":{\"GeocoderMetaData\":{\"kind\":\"district\",\"text\":\"Россия, Москва, Центральный административный округ, Таганский район\",\"precision\":\"other\",\"Address\":{\"country_code\":\"RU\",\"formatted\":\"Россия, Москва, Центральный административный округ, Таганский район\",\"Components\":[{\"kind\":\"country\",\"name\":\"Россия\"},{\"kind\":\"province\",\"name\":\"Центральный федеральный округ\"},{\"kind\":\"province\",\"name\":\"Москва\"},{\"kind\":\"locality\",\"name\":\"Москва\"},{\"kind\":\"district\",\"name\":\"Центральный административный округ\"},{\"kind\":\"district\",\"name\":\"Таганский район\"}]},\"AddressDetails\":{\"Country\":{\"AddressLine\":\"Россия, Москва, Центральный административный округ, Таганский район\",\"CountryNameCode\":\"RU\",\"CountryName\":\"Россия\",\"AdministrativeArea\":{\"AdministrativeAreaName\":\"Москва\",\"Locality\":{\"LocalityName\":\"Москва\",\"DependentLocality\":{\"DependentLocalityName\":\"Центральный административный округ\",\"DependentLocality\":{\"DependentLocalityName\":\"Таганский район\"}}}}}}}},\"description\":\"Центральный административный округ, Москва, Россия\",\"name\":\"Таганский район\",\"boundedBy\":{\"Envelope\":{\"lowerCorner\":\"37.631927 55.725797\",\"upperCorner\":\"37.699759 55.754796\"}},\"Point\":{\"pos\":\"37.666971 55.74001\"}}}]}}}"
		let decoder = JSONDecoder()
		let Response = try! decoder.decode(YandexResponse.self, from: (data.data(using: String.Encoding.utf8))!)
		XCTAssert(Response.response?.GeoObjectCollection?.featureMember != nil)
		XCTAssert(Response.response?.GeoObjectCollection?.featureMember?.count == 1)
	}

}
