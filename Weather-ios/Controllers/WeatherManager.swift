//
//  WeatherManager.swift
//  Weather-ios
//
//  Created by Thao Truong on 3/28/20.
//  Copyright © 2020 Thao Truong. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func onGetWeatherDone(_ weather : Weather)
    func onError(message : String)
}

class WeatherManager {
    var delegate : WeatherManagerDelegate? = nil
    
    public func getWeatherFrom(_ location: String) {
        let weatherAPI = WeatherAPI()

        weatherAPI.getWeatherFromLocation(location: location, completion: {
            (weather) in
            self.delegate?.onGetWeatherDone(weather)
        })
    }
}
