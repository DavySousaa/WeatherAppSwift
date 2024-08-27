//
//  weatherDate.swift
//  Clima
//
//  Created by Davy Sousa on 24/08/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherDate: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}
struct Main: Decodable {
    let temp: Double
}
struct Weather: Decodable {
    let description: String
    let id: Int
}
