//
//  weatherData.swift
//  Clima
//
//   Created by Fady Magdy on 1/1/2021

import Foundation


struct  WeatherData:Decodable{
    let name:String
    let main:Main
    let weather:[Weather]
    
    
    
}
struct Main: Decodable{
    let temp:Double
    
}
struct Weather:Decodable {
    let id:Int
    
}

