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

    @IBOutlet var seachTextFlied: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        seachTextFlied.delegate = self
    }
    @IBAction func locationButton(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

//MARK - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func seachButton(_ sender: UIButton) {
        seachTextFlied.endEditing(true)
        print(seachTextFlied!) //
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        seachTextFlied.endEditing(true)
        print(seachTextFlied!) // qundo apertar o botão return, além de pesquisar, ecerrar a escrita
        return true
    }
    
    internal func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            seachTextFlied.placeholder = "Digite algo"
            return false
        } // caso o usuario nao digite nada e mesmo assim clique na lupa ou em return, avise-o.
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = seachTextFlied.text {
            weatherManager.feathWeather(cityName: city) // pegando o que o usuário digiou e amarzenando na variável.
        }
        seachTextFlied.text = ""
    }
}

//MARK - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.locationManager.stopUpdatingLocation()
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditioonName)
            self.cityLabel.text =  weather.cityName
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
    
            weatherManager.feathWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
