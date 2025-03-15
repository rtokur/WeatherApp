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
    
    func createRealtimeWeather() async throws -> WeatherModel{
        let url = URL(string: baseURL + "/current.json")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems : [URLQueryItem] = [URLQueryItem(name: "key", value: apiKey), URLQueryItem(name: "q", value: "Istanbul")]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        let (data, _ ) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(WeatherModel.self, from: data)
        return response
    }
}
