//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Rumeysa Tokur on 16.03.2025.
//

import Foundation

class WeatherModel: Codable {
    let location: Location?
    let current: Current?
    var forecast: Forecast?
}

class Location: Codable {
    let name: String?
    let region: String?
    let country: String?
    let lat: Double?
    let lon: Double?
    let tzId: String?
    let localTimeEpoch: Int?
    let localTime: String?

    enum CodingKeys: String, CodingKey {
        case name
        case region
        case country
        case lat
        case lon
        case tzId = "tz_id"
        case localTimeEpoch = "localtime_epoch"
        case localTime = "localtime"
    }
}

class Current: Codable {
    let lastUpdatedEpoch: Int?
    let lastUpdated: String?
    let tempC: Double?
    let tempF: Double?
    let isDay: Int?
    let condition: Condition?
    let windMph: Double?
    let windKph: Double?
    let windDegree: Int?
    let windDir: String?
    let pressureMb: Double?
    let pressureIn: Double?
    let precipMm: Double?
    let precipIn: Double?
    let humidity: Int?
    let cloud: Int?
    let feelslikeC: Double?
    let feelslikeF: Double?
    let windChillC: Double?
    let windChillF: Double?
    let heatIndexC: Double?
    let heatIndexF: Double?
    let dewPointC: Double?
    let dewPointF: Double?
    let visKm: Int?
    let visMiles: Int?
    let uv: Double?
    let gustMph: Double?
    let gustKph: Double?

    enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMb = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case precipIn = "precip_in"
        case humidity
        case cloud
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case windChillC = "windchill_c"
        case windChillF = "windchill_f"
        case heatIndexC = "heatindex_c"
        case heatIndexF = "heatindex_f"
        case dewPointC = "dewpoint_c"
        case dewPointF = "dewpoint_f"
        case visKm = "vis_km"
        case visMiles = "vis_miles"
        case uv
        case gustMph = "gust_mph"
        case gustKph = "gust_kph"
    }
}

class Condition: Codable {
    let text: String?
    let icon: String?
    let code: Int?
}

class Forecast: Codable{
    let forecastday: [ForecastDay]?
}

class ForecastDay: Codable{
    let date: String?
    let dateEpoch: Int?
    let day: DayWeather?
    let astro: AstroData?
    let hour: [HourlyWeather]?
    
    enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case day
        case astro
        case hour
    }
}

class DayWeather: Codable{
    let maxtempC: Double?
    let maxtempF: Double?
    let mintempC: Double?
    let mintempF: Double?
    let avgtempC: Double?
    let avgtempF: Double?
    let maxwindMph: Double?
    let maxwindKph: Double?
    let totalprecipMm: Double?
    let totalprecipIn: Double?
    let totalsnowCm: Double?
    let avgvisKm: Double?
    let avgvisMiles: Double?
    let avghumidity: Int?
    let dailyWillItRain: Int?
    let dailyChanceOfRain: Int?
    let dailyWillItSnow: Int?
    let dailyChanceOfSnow: Int?
    let condition: Condition?
    let uv: Double?
    
    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case maxtempF = "maxtemp_f"
        case mintempC = "mintemp_c"
        case mintempF = "mintemp_f"
        case avgtempC = "avgtemp_c"
        case avgtempF = "avgtemp_f"
        case maxwindMph = "maxwind_mph"
        case maxwindKph = "maxwind_kph"
        case totalprecipMm = "totalprecip_mm"
        case totalprecipIn = "totalprecip_in"
        case totalsnowCm = "totalsnow_cm"
        case avgvisKm = "avgvis_km"
        case avgvisMiles = "avgvis_miles"
        case avghumidity
        case dailyWillItRain = "daily_will_it_rain"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case dailyWillItSnow = "daily_will_it_snow"
        case dailyChanceOfSnow = "daily_chance_of_snow"
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
    let timeEpoch: Int?
    let time: String?
    let tempC: Double?
    let tempF: Double?
    let isDay: Int?
    let condition: Condition?
    let windMph: Double?
    let windKph: Double?
    let windDegree: Int?
    let windDir: String?
    let pressureMb: Double?
    let pressureIn: Double?
    let precipMm: Double?
    let precipIn: Double?
    let snowCm: Double?
    let humidity: Int?
    let cloud: Int?
    let feelslikeC: Double?
    let feelslikeF: Double?
    let windChillC: Double?
    let windChillF: Double?
    let heatIndexC: Double?
    let heatIndexF: Double?
    let dewPointC: Double?
    let dewPointF: Double?
    let willItRain: Int?
    let chanceOfRain: Int?
    let willItSnow: Int?
    let chanceOfSnow: Int?
    let visKm: Double?
    let visMiles: Double?
    let gustMph: Double?
    let gustKph: Double?
    let uv: Double?

    
    enum CodingKeys: String, CodingKey {
        case timeEpoch = "time_epoch"
        case time
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMb = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case precipIn = "precip_in"
        case snowCm = "snow_cm"
        case humidity
        case cloud
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case windChillC = "windchill_c"
        case windChillF = "windchill_f"
        case heatIndexC = "heatindex_c"
        case heatIndexF = "heatindex_f"
        case dewPointC = "dewpoint_c"
        case dewPointF = "dewpoint_f"
        case willItRain = "will_it_rain"
        case chanceOfRain = "chance_of_rain"
        case willItSnow = "will_it_snow"
        case chanceOfSnow = "chance_of_snow"
        case visKm = "vis_km"
        case visMiles = "vis_miles"
        case gustMph = "gust_mph"
        case gustKph = "gust_kph"
        case uv
    }

}
