//
//  Weather.swift
//  Weather-ios
//
//  Created by Thao Truong on 3/27/20.
//  Copyright © 2020 Thao Truong. All rights reserved.
//

import Foundation

class Weather {
    var temperature : Double? = 0.0
    var location : String? = ""
    var weatherConditionUrl: String? = ""
    
    func celciusTemp(temp: Double) -> String {
        return (String(format:"%.1f", self.temperature ?? 0.0) + "°C")
    }
    
    class func suggestedLocations() -> Array<String> {
        return [
            "London",
            "Paris",
            "melbourne",
            "tokyo",
            "hanoi",
            "bangkok",
            "hongkong",
            "taiwan",
            "singapore",
            "Shanghai",
            "cambodia",
            "Dhaka",
            "Osaka",
            "Manila",
            "Los Angeles",
            "Jakarta",
            "Seoul",
            "Nagoya",
            "Chicago",
            "Wuhan",
            "Houston",
            "Fukuoka",
        ]
    }
}
