//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Selin Samray on 5.07.2025.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    @Published var placemarkName: String?
    
    override init() {
        super.init()
        manager.delegate = self
        
    }
    
    func requestLocation() {
        isLoading = true
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location.coordinate
        self.isLoading = false
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                let district = placemark.subAdministrativeArea ?? ""
                let city = placemark.locality ?? ""
                let fullName: String
                if district.isEmpty {
                    fullName = city
                } else if district == city {
                    fullName = district
                } else {
                    fullName = "\(district), \(city)"
                }
                
                DispatchQueue.main.async {
                    self.placemarkName = fullName
                }
            } else {
                DispatchQueue.main.async {
                    self.placemarkName = "Unknown Location"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location.",error)
        isLoading = false
    }
    
    func getCityAndSubLocality(from location: CLLocation, completion: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                let subLocality = placemark.subLocality ?? ""
                let city = placemark.locality ?? ""             
                let full = subLocality.isEmpty ? city : "\(subLocality), \(city)"
                completion(full)
            } else {
                completion("Unknown Location")
            }
        }
    }
}
