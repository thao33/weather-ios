//
//  ViewController.swift
//  Weather-ios
//
//  Created by Thao Truong on 3/27/20.
//  Copyright © 2020 Thao Truong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WeatherManagerDelegate {
//    func onGetWeatherFromAPIDone(_ weather: Weather) {
//        print("really???")
//    }
//
//    func onGetWeatherFromAPIError(message: String) {
//        print("kkdkddk")
//    }
//
    @IBOutlet weak var edtLocationSearch: UITextField!
    
    @IBOutlet weak var imgWeatherCondition: UIImageView!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var tblAutoComplete: UITableView!
    
    var weather : Weather? = nil
    var weatherManager: WeatherManager? = nil
    var location : String = ""
    var suggestedLocationList: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherManager = WeatherManager()
        self.weatherManager?.delegate = self
        tblAutoComplete.delegate = self
        tblAutoComplete.dataSource = self
        tblAutoComplete.isHidden = true
//        let tmpLocation = "hanoi"
//        self.weatherManager?.getWeatherFrom(location: tmpLocation)
        
//        edtLocationSearch.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        

    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0.0000001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.0000001
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.suggestedLocationList.count)
        return self.suggestedLocationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteCell") as! AutoCompleteCell
        cell.textLabel?.text = self.suggestedLocationList[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        print(self.suggestedLocationList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let location = cell?.textLabel?.text ?? "default"
        print("didselectRowAt=========")
        print(location)
        if (location != "default") {
            edtLocationSearch.text = location
            DispatchQueue.global(qos: .default).async {
    //                    sleep(5)
                self.weatherManager?.getWeatherFrom(location)
            }
        }
    }
    
    @IBAction func edittingChanged(_ sender: Any) {
        let tmpLocation : String = edtLocationSearch.text ?? ""
        let isCurrentLocationBlank = location.count == 0
        if  isCurrentLocationBlank || location != tmpLocation {
            location = tmpLocation.copy() as! String
        }
        let suggestedLocation = Weather.suggestedLocations()
        print(location)
        self.suggestedLocationList = suggestedLocation.filter { (item) -> Bool in
            item.lowercased().contains(location.lowercased())
        }
        if (self.suggestedLocationList.count == 0) {
            tblAutoComplete.isHidden = true
            return
        } else {
            tblAutoComplete.reloadData()
            tblAutoComplete.isHidden = false
        }
    }
    
    func showWeatherToScreen() {
        lblTemperature.text = weather?.celciusTemp(temp: weather?.temperature ?? 0.0)
        lblLocation.text = self.weather?.location
        print("showWeatherToScreen")
        tblAutoComplete.isHidden = true
    }
    
    func onGetWeatherDone(_ weather: Weather) {
        self.weather = weather
        imgWeatherCondition.download(fromUrl: weather.weatherConditionUrl ?? "")
        showWeatherToScreen()
    }
    
    func onError(message: String) {
        print("error")
    }
    
}

