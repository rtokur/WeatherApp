//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Rumeysa Tokur on 16.03.2025.
//

import Foundation

class WeatherViewModel {
    private var baseURL = "https://api.weatherapi.com/v1"
    private var apiKey = "11ed0746e73849fa8cf141423251503"
    
    func createRealtimeWeather(otherUrl: String, lan: Double, lon: Double, days: String) async throws -> WeatherModel{
        let url = URL(string: baseURL + otherUrl)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems : [URLQueryItem] = [URLQueryItem(name: "key", value: apiKey), URLQueryItem(name: "q", value: "\(lan),\(lon)"), URLQueryItem(name: "days", value: days)]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        let (data, _ ) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(WeatherModel.self, from: data)
        return response
    }
    
    func getForecastWeather(lan: Double, lon: Double) async throws -> WeatherModel {
        let response: WeatherModel = try await createRealtimeWeather(otherUrl: "/forecast.json", lan: lan, lon: lon, days: "7")
        return response
    }
}
