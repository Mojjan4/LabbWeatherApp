//
//  WeatherData.swift
//  labbWeather
//
//  Created by Christopher Persson on 2020-03-13.
//  Copyright © 2020 Christopher Persson. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let coord: Coordinated
    let sys: CountryName
    
}

struct Main: Codable {
    let temp: Float
    let temp_min: Float
    let temp_max: Float
    let humidity: Float
}

struct Weather: Codable {
    let description: String
    let main: String
    let id: Int
}

struct Coordinated: Codable {
    let lon: Float
    let lat: Float
}

struct CountryName: Codable {
    let country: String
}

