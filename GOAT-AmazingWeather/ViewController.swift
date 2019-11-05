//
//  ViewController.swift
//  GOAT-AmazingWeather
//
//  Created by Ren-Kai Yeh on 11/4/19.
//  Copyright © 2019 Sponty, LLC. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet var tableView: UITableView!
    
    @IBAction func requestLocationPermissions(_ sender: Any) {
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .denied || status == .restricted {
            displayAlert("Location Disabled", "Please update your permissions in the Settings")
        } else {
            displayAlert("Location Already Enabled", "")
        }
    }
    
    var selectedRowIndex = Int()
    let locationManager = CLLocationManager()
    var highLowTemperatures = [(day: String, summary: String, icon: String, high: Int, low: Int)]()
    
    // CONSTANTS
    let API_KEY = API_KEY_DARK_SKY
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: LocationMGR Callback
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            if let coordinates = manager.location?.coordinate {
                getWeatherData(coordinates)
            }
        }
    }

    // MARK: TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highLowTemperatures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! mainWeatherTableViewCell
        
        cell.weatherImg.image = UIImage(named: highLowTemperatures[indexPath.row].icon)
        cell.dayOfTheWeek.text = highLowTemperatures[indexPath.row].day
        cell.highLowLabel.text = "H: \(highLowTemperatures[indexPath.row].high)  |  L: \(highLowTemperatures[indexPath.row].low)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRowIndex = indexPath.row
        self.performSegue(withIdentifier: "detail", sender: self)
    }
    
    // MARK: Request & Parse JSON
    func getWeatherData(_ coordinates: CLLocationCoordinate2D) {
        let userLatitude = coordinates.latitude
        let userLongitude = coordinates.longitude
        
        let darkSkyURL = "https://api.darksky.net/forecast/\(API_KEY)/\(userLatitude),\(userLongitude)"
        
        AF.request(darkSkyURL)
            .validate(statusCode: 200..<300).responseJSON { (weatherReport) in
                switch weatherReport.result {
                case .success(let json):
                    if let weatherData = json as? [String:Any] {
                        self.formatJSON(weatherData)
                    }
                case .failure(let error):
                    print("DarkSky Failed: \(error)")
                }
        }
    }
    
    func formatJSON(_ json: [String : Any]) {
        if let daily = json["daily"] as? [String : Any] {
            if let data = daily["data"] as? [[String : Any]] {
                
                var increment = 0 // Use increment to get upcoming days
                for dailyWeather in data { // Parse through data
                    var dayOfWeather = String()
                    
                    let dayOfWeek = Calendar.current.date(byAdding: .day, value: increment, to: Date())
                    if dayOfWeek != nil, dayOfWeek!.dayOfWeek() != nil {
                        dayOfWeather = dayOfWeek!.dayOfWeek()!
                    }
                    
                    increment += 1
                    
                    var weatherIcon = String()
                    var summary = String()
                    
                    var highs = Int()
                    var lows = Int()
                    
                    if let icon = dailyWeather["icon"] as? String {
                        weatherIcon = icon + ".png"
                    }
                    
                    if let sum = dailyWeather["summary"] as? String {
                        summary = sum
                    }
                    
                    if let tempHigh = dailyWeather["temperatureMax"] as? Double {
                        highs = Int(round(tempHigh))
                    }
                    
                    if let tempLow = dailyWeather["temperatureMin"] as? Double {
                        lows = Int(round(tempLow))
                    }
                    
                    highLowTemperatures.append((day: dayOfWeather, summary: summary, icon: weatherIcon, high: highs, low: lows))
                }
                
                tableView.reloadData()
            }
        }
    }
    
    func displayAlert(_ msgTitle: String, _ msgDetail: String) {
        let alert = UIAlertController(title: msgTitle, message:msgDetail, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let info = segue.destination as! detailViewController
            info.dayOfTheWeek = highLowTemperatures[selectedRowIndex].day
            info.highLow = "H: \(highLowTemperatures[selectedRowIndex].high)  |  L: \(highLowTemperatures[selectedRowIndex].low)"
            info.iconStr = highLowTemperatures[selectedRowIndex].icon
            info.daySummary = highLowTemperatures[selectedRowIndex].summary
        }
    }
}

// MARK: Date Ext.
extension Date { // Date Formatter to get Day of Week
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
