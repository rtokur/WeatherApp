//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Rumeysa Tokur on 16.03.2025.
//

import Foundation

class WeatherViewModel{

    //MARK: - Properties
    private let weatherService = WeatherService()
    
    var forecastWeather: ForecastWeatherModel?
    var historyWeather: HistoryWeatherModel?
    
    var onDataUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    //MARK: - Functions
    func getForecastWeather(lan: Double, lon: Double){
        weatherService.getForecastWeather(lan: lan, lon: lon) { [weak self] result in
            if let self = self{
                switch result{
                case .success(let forecast):
                    self.forecastWeather = forecast
                    DispatchQueue.main.async {
                        self.onDataUpdated?()
                    }
                case.failure(let failure):
                    DispatchQueue.main.async {
                        self.onError?(failure)
                    }
                }
            }
            
        }
    }
    
    func getHistoryWeather(lan: Double, lon: Double, dt: String){
        weatherService.getHistoryWeather(lan: lan, lon: lon, dt: dt) { [weak self] result in
            if let self = self {
                switch result {
                case .success(let history):
                    self.historyWeather = history
                    DispatchQueue.main.async {
                        self.onDataUpdated?()
                    }
                case .failure(let failure):
                    DispatchQueue.main.async {
                        self.onError?(failure)
                    }
                }
            }
        }
    }
    
    func forecast(at index: Int) -> ForecastDay? {
        return forecastWeather?.forecast?.forecastday?[index]
    }
    
    func history(at index: Int) -> ForecastDay? {
        return historyWeather?.forecast?.forecastday?[index]
    }
    
    func hourlyWeatherData() -> [HourlyWeather]? {
        guard let hours = forecastWeather?.forecast?.forecastday?.first?.hour else { return [] }

        var hourss = hours.filter { $0.time! > currentDate() }
        
        if let nextDayHours = forecastWeather?.forecast?.forecastday?[1].hour,
           hourss.count < 12 {
            let missingCount = 12 - hourss.count
            for i in 0..<missingCount {
                hourss.append(nextDayHours[i])
            }
        }
        return hourss
    }
    
    func forecastExceptToday() -> [ForecastDay]? {
        return forecastWeather?.forecast?.forecastday?.filter { $0.date != currentDate()}
    }
    
    func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: Date())
    }
}
