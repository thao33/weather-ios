//
//  ViewController.swift
//  Weather-ios
//
//  Created by Thao Truong on 3/27/20.
//  Copyright © 2020 Thao Truong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WeatherManagerDelegate {

    @IBOutlet weak var edtLocationSearch: UITextField!
    @IBOutlet weak var imgWeatherCondition: UIImageView!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var tblAutoComplete: UITableView!
    
    var weather : Weather? = nil
    var weatherManager: WeatherManager? = nil
    var location : String = ""
    var suggestedLocationList: Array<String> = []
    private var lastTyping : Double = 0
    private let lock = NSLock()
    private var lastRequestKeyword : String = ""
    private var lastestIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherManager = WeatherManager()
        self.weatherManager?.delegate = self
        tblAutoComplete.delegate = self
        tblAutoComplete.dataSource = self
        tblAutoComplete.isHidden = true
    }

    @IBAction func onSearchPressed(_ sender: Any) {
        let searchingKeyword = edtLocationSearch.text ?? "Vietnam"
        lastestIndex = lastestIndex + 1
        getSuggesstion("User", searchingKeyword)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0.0000001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.0000001
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suggestedLocationList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteCell") as! AutoCompleteCell
        cell.textLabel?.text = self.suggestedLocationList[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let location = cell?.textLabel?.text ?? "default"
        if (location != "default") {
            edtLocationSearch.text = location
                            self.weatherManager?.getWeatherFrom(location)
     
        }
    }

    @IBAction func edittingChanged(_ sender: Any) {
        lastTyping = Date().timeIntervalSince1970
        runTypingChecker()
    }
    
    func runTypingChecker() {
        let index = lastestIndex + 1
        lastestIndex = index
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [unowned self] in
            let currentTime = Date().timeIntervalSince1970
            print("Amount time \(currentTime - self.lastTyping)")
            
            if (currentTime - self.lastTyping) < 1.5 {
                print("Ignore request \(index)")
                return
            }
            if index < self.lastestIndex {
                print("Ignore request \(index)")
                return
            }
            
            print("Make request \(index)")
            let searchingKeyword = self.edtLocationSearch.text ?? "Vietnam"
            self.getSuggesstion("DispatchQueue", searchingKeyword)
        }
    }
    
    private func getSuggesstion(_ sender : String, _ searchingKeyword : String) {
//        lock.lock()
        print("\(sender) getSuggesstion \(lastestIndex) - \(searchingKeyword)")
        let suggestedLocation = Weather.suggestedLocations()
        let location = edtLocationSearch.text ?? ""
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
//        lock.unlock()
    }
    
    private func makeRequest(keyword : String) {
        lock.lock()
        if keyword != lastRequestKeyword {
            lastRequestKeyword = keyword
            print("Let's request \(keyword)")
        }else {
            print("Ignore request \(keyword)")
        }
        lock.unlock()
    }

    
    func showWeatherToScreen() {
        lblTemperature.text = weather?.celciusTemp(temp: weather?.temperature ?? 0.0)
        lblLocation.text = self.weather?.location
        tblAutoComplete.isHidden = true
    }
    
    func onGetWeatherDone(_ weather: Weather) {
        self.weather = weather
        imgWeatherCondition.loadImageFrom(url: weather.weatherConditionUrl ?? "")
        showWeatherToScreen()
    }
    
    func onError(message: String) {
        print("error")
    }
    
}

