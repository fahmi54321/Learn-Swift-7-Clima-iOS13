//
//  WeatherManager.swift
//  Clima
//
//  Created by Fahmi Aziz on 15/03/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    let weatherURL = "Url api weather";
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName : String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees)  {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString : String){
        // 1 create a URL
        if let url = URL(string: urlString){
            // 2 create a URL Session
            let session = URLSession(configuration: .default)
            
            // 3 give the session a task
            let task =  session.dataTask(with: url, completionHandler: handle(data:urlResponse:error:))
            
            // 4 start task
            task.resume()
        }
    }
    
    func handle(data: Data?, urlResponse: URLResponse?, error: Error?){
        if(error != nil){
            self.delegate?.didFailWithError(error: error!)
            return
        }
        
        if let safeData = data{
            let dataString = String(data: safeData, encoding: .utf8)
            if let weather = self.parseJSON(weatherData: safeData){
                
                // bind to view controller
                self.delegate?.didUpdateWeather(weather: weather)
            }
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
