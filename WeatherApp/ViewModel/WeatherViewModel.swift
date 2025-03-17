//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Rumeysa Tokur on 16.03.2025.
//

import Foundation

class WeatherViewModel {
    //MARK: Properties
    private var baseURL = "https://api.weatherapi.com/v1"
    private var apiKey = "11ed0746e73849fa8cf141423251503"
    
    //MARK: Funcstions
    func createWeather<T: Decodable>(otherUrl: String,
                                     lan: Double,
                                     lon: Double,
                                     days: String?,
                                     dt: String?) async throws -> T{
        let url = URL(string: baseURL + otherUrl)!
        var components = URLComponents(url: url,
                                       resolvingAgainstBaseURL: true)!
        let queryItems : [URLQueryItem]
        if days != nil {
            queryItems = [URLQueryItem(name: "key",
                                       value: apiKey),
                          URLQueryItem(name: "q",
                                       value: "\(lan),\(lon)"),
                          URLQueryItem(name: "days",
                                       value: days)]
            components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        }else if dt != nil {
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
        let (data, _ ) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(T.self,
                                                from: data)
        return response
    }
    
    func getForecastWeather(lan: Double,
                            lon: Double) async throws -> ForecastWeatherModel {
        return try await createWeather(otherUrl: "/forecast.json",
                                       lan: lan,
                                       lon: lon,
                                       days: "7",
                                       dt: nil)
    }
    
    func getHistoryWeather(lan: Double,
                           lon: Double,
                           dt: String) async throws -> HistoryWeatherModel {
        return try await createWeather(otherUrl: "/history.json",
                                       lan: lan,
                                       lon: lon,
                                       days: nil,
                                       dt: dt)
    }
}
