//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Rumeysa Tokur on 16.03.2025.
//

import Foundation

class ForecastWeatherModel: Codable {
    let location: Location?
    let current: Current?
    var forecast: Forecast?
}

class HistoryWeatherModel: Codable {
    let location: Location?
    var forecast: Forecast?
}

class Location: Codable {
    let name: String?
    let region: String?
    let country: String?
    let lat: Double?
    let lon: Double?
}

class Current: Codable {
    let tempC: Double?
    let condition: Condition?
    let windKph: Double?
    let uv: Double?

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
        case windKph = "wind_kph"
        case uv
    }
}

class Condition: Codable {
    let text: String?
    let icon: String?

    var iconURL: URL? {
        guard let icon = icon else { return nil }
        let iconURLString = "https:"+icon
        return URL(string: iconURLString)
    }
}

class Forecast: Codable{
    let forecastday: [ForecastDay]?
}

class ForecastDay: Codable{
    let date: String?
    let day: DayWeather?
    let astro: AstroData?
    let hour: [HourlyWeather]?
}

class DayWeather: Codable{
    let maxtempC: Double?
    let mintempC: Double?
    let maxwindKph: Double?
    let totalprecipMm: Double?
    let dailyChanceOfRain: Int?
    let condition: Condition?
    let uv: Double?
    
    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case maxwindKph = "maxwind_kph"
        case totalprecipMm = "totalprecip_mm"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case condition
        case uv
    }
}

class AstroData: Codable{
    let sunrise: String?
    let sunset: String?
    let moonrise: String?
    let moonset: String?
    let moonPhase: String?
    let moonIllumination: Double?
    let isMoonUp: Int?
    let isSunUp: Int?
    
    enum CodingKeys: String, CodingKey {
        case sunrise
        case sunset
        case moonrise
        case moonset
        case moonPhase = "moon_phase"
        case moonIllumination = "moon_illumination"
        case isMoonUp = "is_moon_up"
        case isSunUp = "is_sun_up"
    }
}

class HourlyWeather: Codable{
    let time: String?
    let tempC: Double?
    let condition: Condition?
    let windKph: Double?
    let chanceOfRain: Int?
    let uv: Double?

    
    enum CodingKeys: String, CodingKey {
        case time
        case tempC = "temp_c"
        case condition
        case windKph = "wind_kph"
        case chanceOfRain = "chance_of_rain"
        case uv
    }

}
