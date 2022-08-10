//
//  WeatherManager.swift
//  WeatherDemo
//
//  Created by Stanly Shiyanovskiy on 10.08.2022.
//

import CoreLocation
import Foundation

final class WeatherManager {
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=f98e9a4853b6542f39b4d4bd709c0f99&units=metric") else { fatalError("Missing URL") }
        
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather data") }
        
        return try JSONDecoder().decode(ResponseBody.self, from: data)
    }
}

struct ResponseBody: Codable {
    let coord: CoordinatesResponse
    let weather: [WeatherResponse]
    let main: MainResponse
    let name: String
    let wind: WindResponse
    
    struct CoordinatesResponse: Codable {
        let lon: Double
        let lat: Double
    }
    
    struct WeatherResponse: Codable {
        let id: Double
        let main: String
        let description: String
        let icon: String
    }
    
    struct MainResponse: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Double
        let humidity: Double
    }
    
    struct WindResponse: Codable {
        let speed: Double
        let deg: Double
    }
}
