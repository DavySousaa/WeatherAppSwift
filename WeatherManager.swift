//
//  WeatherManager.swift
//  Clima
//
//  Created by Davy Sousa on 05/08/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1e156c7f8d14a8ac058b708b0ecc3f95&units=metric"
    
    // utilizando a url padrão sem o paremetro do nome da cidade, pois vai ser dado pelo usuário.
    // weather?appid=1e156c7f8d14a8ac058b708b0ecc3f95 = minha chave da api
    // &units=metric" = para transformar a temp para celcius
    
    var delegate: WeatherManagerDelegate?
    
    func feathWeather (cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"// O nome da cidade vem depois do "&q=" por isso essa concatenação
        self.performRequest(urlString: urlString)
    }
    
    func feathWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString =  "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    func performRequest (urlString: String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeDate  = data {
                    if let weather = self.parseJSON(weatherData: safeDate) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }

                    
                }
            }
            task.resume()
        }
    }
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decoderDate = try decoder.decode(WeatherDate.self, from: weatherData)
            let id = decoderDate.weather[0].id
            let name = decoderDate.name
            let temp = decoderDate.main.temp
            let weather = WeatherModel(cityName: name, conditionID: id, temperature: temp)
            
            print(weather.conditioonName)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

