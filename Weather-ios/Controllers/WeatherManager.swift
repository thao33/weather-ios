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

class WeatherManager: WeatherAPIDelegate {
    func onGetWeatherFromAPIError(message: String) {
        print("onGetWeatherFromAPIError")
    }
    
    func onGetWeatherFromAPIDone(_ weather: Weather) {
        print("onGetWeatherFromAPIDone")
        DispatchQueue.main.sync {
            self.delegate?.onGetWeatherDone(weather)
        }
    }

    var delegate : WeatherManagerDelegate? = nil
    private var weatherAPI : WeatherAPI? = nil
    
    private func getWeatherDataFromAPI(_ location: String) {
        weatherAPI?.getWeatherFromLocation(location: location)
    }
    
    public func getWeatherFrom(_ location: String) {
        weatherAPI = WeatherAPI()
        weatherAPI?.delegate = self as WeatherAPIDelegate
        DispatchQueue.global(qos: .default).async {
            self.getWeatherDataFromAPI(location)
        }
    }
    
}
