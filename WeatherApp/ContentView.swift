//
//  ContentView.swift
//  WeatherApp
//
//  Created by Selin Samray on 3.07.2025.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var weatherData: WeatherData?
    
    var body: some View {
        ZStack{
            backgroundGradient
                .ignoresSafeArea()
            VStack {
                if let weatherData = weatherData {
                    Text("\(Int(weatherData.temperature))°C")
                        .font(.custom("", size: 70))
                        .padding()
                        .padding(.top, 10)
                    
                    VStack {
                        Text("\(weatherData.locationName)")
                            .font(.title).bold()
                            .foregroundColor(.gray)
                    }
                    Image(systemName: weatherIcon(for: weatherData.condition))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(weatherColor(for: weatherData.condition))
                    Spacer()
                    
                } else {
                    ProgressView()
                    
                }
            }
            .frame(width: 300, height: 300)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .onAppear {
                locationManager.requestLocation()
                
            }
            .onReceive(locationManager.$location) { location in
                guard let location = location else { return }
                fetchWeatherData(for: location)
            }
        }
    }
    
    private func fetchWeatherData(for location: CLLocation) {
        let apiKey = "db2d80117533d3fd570eab975abb6c1a"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                
                
                DispatchQueue.main.async {
                    weatherData = WeatherData(locationName: weatherResponse.name, temperature: weatherResponse.main.temp, condition: weatherResponse.weather.first?.description ?? "")
                    
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func weatherIcon(for conditions: String) -> String {
        switch conditions.lowercased() {
        case let c where c.contains("cloud"):
            return "cloud.fill"
        case let c where c.contains("rain"):
            return "cloud.rain.fill"
        case let c where c.contains("sun"), let c where c.contains("clear"):
            return "sun.max.fill"
        case let c where c.contains("snow"):
            return "snow"
        default:
            return "questionmark"
        }
    }
    
    func weatherColor(for conditions: String) -> Color {
        switch conditions.lowercased() {
        case let c where c.contains("cloud"):
            return .gray
        case let c where c.contains("rain"):
            return .blue
        case let c where c.contains("sun"), let c where c.contains("clear"):
            return .yellow
        case let c where c.contains("snow"):
            return .white
        default:
            return .gray
        }
    }
    
    var backgroundGradient: LinearGradient {
        guard let condition = weatherData?.condition.lowercased() else {
            // Default background if no data
            return LinearGradient(colors: [.gray, .blue], startPoint: .top, endPoint: .bottom)
        }
        
        switch condition {
        case let c where c.contains("cloud"):
            return LinearGradient(colors: [.gray, .white], startPoint: .top, endPoint: .bottom)
        case let c where c.contains("rain"):
            return LinearGradient(colors: [.blue, .gray], startPoint: .top, endPoint: .bottom)
        case let c where c.contains("sun"), let c where c.contains("clear"):
            return LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)
        case let c where c.contains("snow"):
            return LinearGradient(colors: [.white, .gray], startPoint: .top, endPoint: .bottom)
        default:
            return LinearGradient(colors: [.gray, .blue], startPoint: .top, endPoint: .bottom)
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
