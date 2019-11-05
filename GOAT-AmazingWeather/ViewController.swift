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
            return
        } else if status == .denied || status == .restricted {
            displayAlert("Location Disabled", "Please update your permissions in the Settings")
        } else {
            displayAlert("Location Enabled", "")
        }

        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func displayAlert(_ msgTitle: String, _ msgDetail: String) {
        let alert = UIAlertController(title: msgTitle, message:msgDetail, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let userLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        getWeatherData(userLocation)
    
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location was unabled to be found or updated")
    }
    
    func getWeatherData(_ coordinates: CLLocationCoordinate2D) {
        let userLatitude = coordinates.latitude
        let userLongitude = coordinates.longitude
        
        let darkSkyURL = "https://api.darksky.net/forecast/f68ef4bc753bae8ef3e8ce9b8f337a40/\(userLatitude),\(userLongitude)"
        
        AF.request(darkSkyURL)
            .validate(statusCode: 200..<300).responseJSON { (weatherReport) in
                switch weatherReport.result {
                case .success(let json):
                    print(json)
                case .failure(let error):
                    print("Failed to Query from DarkSky")
                }
        }
    }
    
    // Request location access
    // Get the city/zip
    // use the zip on dark sky to determine weather
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func enableLocation() {
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! mainWeatherTableViewCell
        
        
        return cell
    }
}

