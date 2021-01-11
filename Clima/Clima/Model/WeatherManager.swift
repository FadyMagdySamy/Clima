//
//  weatherManager.swift
//  Clima
//
//  Created by Fady Magdy on 1/1/2021

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather:WeatherModel)
    func didFailWithError(error:Error)
}
struct WeatherManager{
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?&appid=c10e15e3bb73fca113955c096ebdcc16&units=metric"
  
    
    
    var delegate:WeatherManagerDelegate?
    func fetchWeather(longitude: Double,latitude: Double){
        let StringUrl = "\(weatherUrl)&lon=\(longitude)&lat=\(latitude)"
      // print(StringUrl)
        
        performRequest(with: StringUrl)
        
    }
    
    func fetchWeather(cityName:String){
        let StringUrl = "\(weatherUrl)&q=\(cityName)"
        performRequest(with: StringUrl)
        
    }
    
    func performRequest(with urlString:String){
        //1. create a url
        if let url = URL(string: urlString){
            //2.create a URLSession
            let session = URLSession(configuration: .default)
            //3. give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    // let StringData = String(data: safeData, encoding: .utf8)
                    if let weather =  parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather:weather)
                    }
                }
            }
            //4. start the task
            task.resume()
        }
        
    }
    
    
    func parseJSON(_ weatherData: Data)->WeatherModel?{
        // print(weatherData)
        
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            
           
            let temperature = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, temperature: temperature, cityName: name)
            return weather
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

