//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // permission location user (gps) (jangan lupa tambahkan di info plist)
        // Privacy - Location When In Use Usage Description
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // delegate location
        locationManager.delegate = self
        
        //  delegate weather
        weatherManager.delegate = self
        
        //  delegate search
        searchTextField.delegate = self
    }


    @IBAction func searchPressed(_ sender: UIButton) {
        //dismiss keyboard ketika selesai
        searchTextField.endEditing(true)
        
        print(searchTextField.text)
    }
    
    
    
    
}

// listen textfield
extension WeatherViewController: UITextFieldDelegate{
    // aksi ketika klik return value di keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //dismiss keyboard ketika selesai
        searchTextField.endEditing(true)
        
        print(searchTextField.text)
        return true
    }
    
    // aksi untuk clear input text
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
    
    // validasi input text
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if((textField.text ?? "").isEmpty){
            textField.placeholder = "Type something"
            return false
        }else{
            return true
        }
    }
}

// listen weather manager
extension WeatherViewController: WeatherManagerDelegate{
    // listen delegate weather
    func didUpdateWeather(weather: WeatherModel){
        
        // handle ketika loading
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    // listen delegate error
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            locationManager.stopUpdatingLocation()
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        <#code#>
    }
}

