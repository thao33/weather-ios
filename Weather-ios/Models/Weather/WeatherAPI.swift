//
//  WeatherAPI.swift
//  Weather-ios
//
//  Created by Thao Truong on 3/28/20.
//  Copyright © 2020 Thao Truong. All rights reserved.
//

import Foundation

protocol WeatherAPIDelegate {
    func onGetWeatherFromAPIDone(_ weather : Weather)
    func onGetWeatherFromAPIError(message : String)
}

class WeatherAPI {
    let REQUEST_OK = "200"
    var delegate : WeatherAPIDelegate? = nil
    
    private func notifyError(message : String) {
        DispatchQueue.main.sync {
//            self.delegate?.onError(message: message)
        }
    }
    
    private func requestCompletion(data : Data?, response : URLResponse? , error : Error?) {
        if ((error) != nil) {
            notifyError(message: error?.localizedDescription ?? "Unknown error")
            return
        }
        
        if (data == nil) {
            notifyError(message: "Data is nil")
            return
        }

        let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
        
        var code = ""
        
        if let codeValue = json?.value(forKey: "cod") as? Int {
            code = String(codeValue)
        }
        
        if code == "" {
            code = json?.value(forKey: "cod") as? String ?? ""
        }
    
        if code != self.REQUEST_OK {
            let message = "sth went wrong"
            notifyError(message: message)
            return
        }

        let weather = parseWeather(jWeather: json!)
        self.delegate?.onGetWeatherFromAPIDone(weather)
    }
    
    private func parseWeather(jWeather  : NSDictionary) -> Weather {
        let weather = Weather()
        let mainWithTemperature = jWeather.value(forKey: "main") as! NSDictionary
        let weatherConditionArray = jWeather.value(forKey: "weather") as! Array<NSDictionary>
        let iconCode = weatherConditionArray.first?.value(forKey: "icon") as! String
    
        weather.location = jWeather.value(forKey: "name") as? String
        weather.temperature = mainWithTemperature.value(forKey: "temp") as? Double
        weather.weatherConditionUrl = WeatherHelper.getURLWeatherFromIcon(iconCode)
        return weather
    }
    
    public func getWeatherFromLocation(location: String) {
        var request = URLRequest(url: URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(location)&units=metric&appid=d7e833c8105f1c1cb33eb8dfe19615ac")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared.dataTask(with: request, completionHandler: requestCompletion(data:response:error:))
        session.resume()
    }
    
}
