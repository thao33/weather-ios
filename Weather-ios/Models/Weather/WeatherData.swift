//
//  WeatherData.swift
//  Weather-ios
//
//  Created by Thao Truong on 3/28/20.
//  Copyright © 2020 Thao Truong. All rights reserved.
//

import Foundation

struct WeatherData : Decodable {
    var temperature: Double
}

struct Coordinate: Decodable {
    var lon: Double
    var lat: Double
}

struct WeatherFromAPI: Decodable {
    var id: Int
    var main: String
    var description : String
    var icon: String
}

struct Main: Decodable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Int
    var humidity: Int
}

struct Wind: Decodable {
    var speed: Double
    var deg: Int
}

struct Clouds : Decodable {
    var all: Int
}

struct System: Decodable {
    var type: Int
    var id : Int
    var country: String
    var sunrise: Int
    var sunset : Int
}

struct ResponseData : Decodable {
    var coord: Coordinate
    var weather: Array<WeatherFromAPI>
    var base: String
    var main: Main
    var visibility: Int
    var wind: Wind
    var clouds: Clouds
    var dt: Int
    var sys: System
    var timezone: Int
    var id: Int
    var name: String
    var cod: Int
}
