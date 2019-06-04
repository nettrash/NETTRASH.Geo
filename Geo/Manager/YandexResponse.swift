//
//  Yandexresponse.swift
//  Geo
//
//  Created by Иван Алексеев on 29/05/2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//

import Foundation

struct YandexResponse : Decodable {
	let response: yndxResponseData?
}

struct yndxResponseData : Decodable {
	let GeoObjectCollection: yndxGeoObjectCollection?
}

struct yndxGeoObjectCollection : Decodable {
	let metaDataProperty: yndxMetaDataProperty?
	let featureMember: [yndxFeatureMember]?
}

struct yndxMetaDataProperty : Decodable {
	let GeocoderResponseMetaData: yndxGeocoderResponseMetaData?
}

struct yndxGeocoderResponseMetaData: Decodable {
	let request: String?
	let found: String?
	let results: String?
	let Point: yndxPoint?
	let kind: String?
}

struct yndxPoint : Decodable {
	let pos: String?
}

struct yndxFeatureMember : Decodable {
	let GeoObject: yndxGeoObject?
}

struct yndxGeoObject : Decodable {
	let metaDataProperty: yndxGeoObjectMetaDataProperty?
	let description: String?
	let name: String?
	let boundedBy: yndxBoundedBy?
	let Point: yndxPoint?
}

struct yndxGeoObjectMetaDataProperty : Decodable {
	let GeocoderMetaData: yndxGeocoderMetaData?
}

struct yndxGeocoderMetaData : Decodable {
	let kind: String?
	let text: String?
	let precision: String?
	let Address: yndxAddress?
	let AddressDetails : yndxAddressDetails?
}

struct yndxAddress : Decodable {
	let country_code: String?
	let formatted: String?
	let Components: [yndxAddressComponent]?
}

struct yndxAddressComponent : Decodable {
	let kind: String?
	let name: String?
}

struct yndxAddressDetails : Decodable {
	let Country: yndxAddressDetailsCountry?
}

struct yndxAddressDetailsCountry : Decodable {
	let AddressLine: String?
	let CountryNameCode: String?
	let CountryName: String?
	let AdministrativeArea: yndxCountryAdministrativeArea?
}

struct yndxCountryAdministrativeArea : Decodable {
	let AdministrativeAreaName: String?
	let Locality: yndxCountryLocality?
}

struct yndxCountryLocality : Decodable {
	let LocalityName: String?
	let DependentLocality: yndxCountryDependentLocality?
}

struct yndxCountryDependentLocality : Decodable {
	let DependentLocalityName: String?
	let DependentLocality: yndxCountryDependentLocalityLevel0?
}

struct yndxCountryDependentLocalityLevel0 : Decodable {
	let DependentLocalityName: String?
	let DependentLocality: yndxCountryDependentLocalityLevel1?
}

struct yndxCountryDependentLocalityLevel1 : Decodable {
	let DependentLocalityName: String?
	let DependentLocality: yndxCountryDependentLocalityLevel2?
}

struct yndxCountryDependentLocalityLevel2 : Decodable {
	let DependentLocalityName: String?
	let DependentLocality: yndxCountryDependentLocalityLevel3?
}

struct yndxCountryDependentLocalityLevel3 : Decodable {
	let DependentLocalityName: String?
}

struct yndxBoundedBy : Decodable {
	let Enveloper: yndxBoundedByEnvelope?
}

struct yndxBoundedByEnvelope : Decodable {
	let lowerCorner: String?
	let upperCorner: String?
}

/*
"{\"response\":{\"GeoObjectCollection\":{\"metaDataProperty\":{\"GeocoderResponseMetaData\":{\"request\":\"37.667710,55.732108\",\"found\":\"2\",\"results\":\"1\",\"Point\":{\"pos\":\"37.667710 55.732108\"},\"kind\":\"district\"}},\"featureMember\":[{\"GeoObject\":{\"metaDataProperty\":{\"GeocoderMetaData\":{\"kind\":\"district\",\"text\":\"Россия, Москва, Центральный административный округ, Таганский район\",\"precision\":\"other\",\"Address\":{\"country_code\":\"RU\",\"formatted\":\"Россия, Москва, Центральный административный округ, Таганский район\",\"Components\":[{\"kind\":\"country\",\"name\":\"Россия\"},{\"kind\":\"province\",\"name\":\"Центральный федеральный округ\"},{\"kind\":\"province\",\"name\":\"Москва\"},{\"kind\":\"locality\",\"name\":\"Москва\"},{\"kind\":\"district\",\"name\":\"Центральный административный округ\"},{\"kind\":\"district\",\"name\":\"Таганский район\"}]},\"AddressDetails\":{\"Country\":{\"AddressLine\":\"Россия, Москва, Центральный административный округ, Таганский район\",\"CountryNameCode\":\"RU\",\"CountryName\":\"Россия\",\"AdministrativeArea\":{\"AdministrativeAreaName\":\"Москва\",\"Locality\":{\"LocalityName\":\"Москва\",\"DependentLocality\":{\"DependentLocalityName\":\"Центральный административный округ\",\"DependentLocality\":{\"DependentLocalityName\":\"Таганский район\"}}}}}}}},\"description\":\"Центральный административный округ, Москва, Россия\",\"name\":\"Таганский район\",\"boundedBy\":{\"Envelope\":{\"lowerCorner\":\"37.631927 55.725797\",\"upperCorner\":\"37.699759 55.754796\"}},\"Point\":{\"pos\":\"37.666971 55.74001\"}}}]}}}"
*/
