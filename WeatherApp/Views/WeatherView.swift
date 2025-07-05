//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Selin Samray on 5.07.2025.
//

import SwiftUI

struct WeatherView: View {
    var weather : ResponseBody
    var placeName: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(placeName)
                        .bold().font(.title)
                    
                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))").fontWeight(.light)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                
                VStack {
                    HStack {
                        VStack(spacing: 20) {
                            Image(systemName: weatherLogo(for: weather.weather[0].main))
                                .font(.system(size: 40))
                            
                            Text(weather.weather[0].main)
                        }
                        .frame(width: 150, alignment: .leading)
                        
                        Spacer()
                        
                        Text(weather.main.feelsLike.roundDouble() + "°")
                            .font(.system(size: 100))
                            .fontWeight(.bold)
                            .padding()
                    }
                    Spacer()
                        .frame(height: 80)
                    
                    Image("city-4791269_960_720")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 350)
                    
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Weather now")
                        .bold().padding(.bottom, 8)
                    HStack {
                        WeatherRow(logo: "thermometer", name: "Min temp", value: weather.main.tempMin.roundDouble() + "°")
                        Spacer()
                        WeatherRow(logo: "thermometer", name: "Max temp", value: weather.main.tempMax.roundDouble() + "°")
                    }
                    .padding(.horizontal, 10)
                    
                    HStack{
                        WeatherRow(logo: "wind", name: "Wind speed", value: weather.wind.speed.roundDouble() + " m/s")
                        Spacer()
                        WeatherRow(logo: "humidity", name: "Humidity", value: weather.main.humidity.roundDouble() + "%")
                    }
                    .padding(.horizontal, 10)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.bottom, 20)
                .foregroundColor(Color(hue: 0.636, saturation: 0.941, brightness: 0.419))
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(hue: 0.636, saturation: 0.941, brightness: 0.419))
        .preferredColorScheme(.dark)
        
    }
}

func weatherLogo(for condition: String) -> String {
    switch condition.lowercased() {
    case let c where c.contains("cloud"):
        return "cloud"
    case let c where c.contains("rain"):
        return "cloud.rain"
    case let c where c.contains("clear"), let c where c.contains("sun"):
        return "sun.max"
    case let c where c.contains("snow"):
        return "snow"
    default:
        return "questionmark"
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: previewWeather, placeName: previewWeather.name)
    }
}



