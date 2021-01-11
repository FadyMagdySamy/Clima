//
//  ViewController.swift
//  Clima
//
//  Created by Fady Magdy on 1/1/2021

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
      
        locationManager.requestLocation()
        
    }
    
    var locationManager = CLLocationManager()
    
    
    var weatherManager = WeatherManager()
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        
        searchTextField.endEditing(true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
      
        weatherManager.delegate = self
        searchTextField.delegate = self
       
        
    }
    
}
//MARK: - UItextFieldDelegate

extension WeatherViewController:UITextFieldDelegate{
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        }
        
        else
        {
            searchTextField.placeholder = "type something"
            return false
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
            
            
        }
        
        searchTextField.text = ""
        
    }
}

//MARK: - weatherManagerDelegate

extension WeatherViewController:WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager:WeatherManager, weather:WeatherModel){
        
        /*
         print(weather.cityName)
         print(weather.conditionName)
         print(weather.temperature)
         */
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    
    
    
    
    func didFailWithError(error:Error){
        print(error)
    }
    
    
}

//MARK:  - clLocationManagerDelegate
extension WeatherViewController :CLLocationManagerDelegate{
   
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if locations.last != nil {
            if  let location = locations.last{
                locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
                weatherManager.fetchWeather(longitude: lon, latitude: lat)
            }
        }

    }
}

