//
//  WeatherManager.swift
//  labbWeather
//
//  Created by Christopher Persson on 2020-03-13.
//  Copyright © 2020 Christopher Persson. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func updateWeather (_ weatherManager: WeatherManager, weather: WeatherModel)
    func failError(error: Error)
}


//MARK: - API Weather Link

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let weatherAPIURL = "https://api.openweathermap.org/data/2.5/weather?appid=3b4310048cb13c806afefebf904439be&units=metric"
    
    func fecthWheatherTextField(cityName:String) {
        
        let urlString = "\(weatherAPIURL)&q=\(cityName)"
        request(with: urlString)
    }
    
    func fecthWeatherLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherAPIURL)&lat=\(latitude)&lon=\(longitude)"
        request(with: urlString)
    }
    
    //MARK: - Request API
    
    func request(with urlString: String ) {
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    self.delegate?.failError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if  let finalDataWeather =  self.parseJson(safeData) {
                        self.delegate?.updateWeather(self, weather: finalDataWeather)
                    }
                }
                
                
            }
            
            task.resume()
            
        }
    }
    
    //MARK: - Parse JSON file and save data.
    
    func parseJson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let maxTemp = decodedData.main.temp_max
            let minTemp = decodedData.main.temp_min
            let humidity = decodedData.main.humidity
            let countryName = decodedData.sys.country
            let cityName = decodedData.name
            let description = decodedData.weather[0].description
            
            let weather =
                WeatherModel(countryName: countryName, cityName: cityName, description: description, conditionId: id, humidity: humidity, temperature: temp, minTemp: minTemp, maxTemp: maxTemp)
            
            return weather
            
        } catch {
            delegate?.failError(error: error)
            
            return nil
        }
    }
}
