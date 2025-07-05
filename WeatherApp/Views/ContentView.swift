//
//  ContentView.swift
//  WeatherApp
//
//  Created by Selin Samray on 3.07.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    
    
    var body: some View {
        VStack {
            
            if let location = locationManager.location {
                if let weather = weather{
                    WeatherView(weather: weather, placeName: locationManager.placemarkName ?? weather.name)
                }else{
                    LoadingView()
                        .task{
                            do{
                                weather = try await weatherManager.getCurrentLocation(latitude: location.latitude, longitude: location.longitude)
                                
                            }catch {
                                print("Error getting weather: \(error)")
                            }
                        }
                }
                
            } else {
                if locationManager.isLoading {
                    LoadingView()
                } else {
                    
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
        }
        .background(Color(hue: 0.636, saturation: 0.941, brightness: 0.419))
        .preferredColorScheme(.dark)
        
    }
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

