//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Selin Samray on 4.07.2025.
//

import Foundation
import CoreLocation

struct WeatherData {
    let locationName: String
    let temperature: Double
    let condition: String
    
}

struct WeatherResponse: Codable {
    let name: String
    let main: MainWeather
    let weather: [Weather]
}

struct MainWeather: Codable {
    // Codable: This struct knows how to convert itself to and from data like JSON.
    //          When you use API's or saving sth to disk you use Codable structs.
    let temp: Double
}

struct Weather: Codable {
    let description: String
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
