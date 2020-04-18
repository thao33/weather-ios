//
//  WeatherHelper.swift
//  Weather-ios
//
//  Created by Thao Truong on 3/28/20.
//  Copyright © 2020 Thao Truong. All rights reserved.
//

import Foundation

class WeatherHelper {
    
    class func getURLWeatherFromIcon(_ iconCode: String) -> String {
        return "http://openweathermap.org/img/wn/\(iconCode)@2x.png"
    }
}
