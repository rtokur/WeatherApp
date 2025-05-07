//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Rumeysa Tokur on 7.05.2025.
//

import Foundation

class WeatherService {
    //MARK: - Properties
    private var baseURL = "https://api.weatherapi.com/v1"
    private var apiKey = "99fe3f5862b840d2ac520632252904"
    
    //MARK: - Functions
    private func createWeather<T: Decodable>(otherUrl: String,
                                     lan: Double,
                                     lon: Double,
                                     days: String?,
                                     dt: String?,
                                     completion: @escaping (Result<T,
                                                                   Error>) -> Void){
        let url = URL(string: baseURL + otherUrl)!
        var components = URLComponents(url: url,
                                       resolvingAgainstBaseURL: true)!
        let queryItems : [URLQueryItem]
        if let days = days {
            queryItems = [URLQueryItem(name: "key",
                                       value: apiKey),
                          URLQueryItem(name: "q",
                                       value: "\(lan),\(lon)"),
                          URLQueryItem(name: "days",
                                       value: days)]
            components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        }else if let dt = dt {
            queryItems = [URLQueryItem(name: "key",
                                       value: apiKey),
                          URLQueryItem(name: "q",
                                       value: "\(lan),\(lon)"),
                          URLQueryItem(name: "dt",
                                       value: dt)]
            components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: 0)))
                return
            }
            do{
                let dresponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(dresponse))
            }catch{
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getForecastWeather(lan: Double,
                            lon: Double, completion: @escaping (Result<ForecastWeatherModel,Error>) -> Void) {
        createWeather(otherUrl: "/forecast.json",
                                       lan: lan,
                                       lon: lon,
                                       days: "15",
                                       dt: nil,
                                       completion: completion)
    }
    
    func getHistoryWeather(lan: Double,
                           lon: Double,
                           dt: String,
    completion: @escaping (Result<HistoryWeatherModel,Error>) -> Void) {
        createWeather(otherUrl: "/history.json",
                                       lan: lan,
                                       lon: lon,
                                       days: nil,
                                       dt: dt,
                                       completion: completion)
    }
}
