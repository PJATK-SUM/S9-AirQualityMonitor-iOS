//
//  Topic.swift
//  AirQualityMonitor-iOS
//
//  Created by Jakub Ziembiński on 18/11/2018.
//  Copyright © 2018 Jakub Ziembiński. All rights reserved.
//

enum Topic: String {
    case pm2dot5 = "pm2dot5"
    case pm10 = "pm10"
    case humidity = "hum"
    case temperature = "temp"
    case pressure = "press"
    case allHash = "#"
    case unknown
    
    static let all: [Topic] = [.temperature, .pm2dot5, .humidity, .pm10, .pressure]
    
    var path: String {
        return "ziembinski_j/feeds/\(self.rawValue)"
    }
    
    var readableName: String {
        switch self {
        case .pm2dot5:
            return "PM 2.5"
        case .pm10:
            return "PM 10"
        case .humidity:
            return "Humidity"
        case .temperature:
            return "Temperature"
        case .pressure:
            return "Atmospheric pressure"
        case .allHash, .unknown:
            return ""
        }
    }
    
    var unit: String {
        switch self {
        case .pm2dot5, .pm10:
            return "µg/m3"
        case .humidity:
            return "%"
        case .temperature:
            return "℃"
        case .pressure:
            return "hPa"
        case .allHash, .unknown:
            return ""
        }
    }
    
    static func from(path: String) -> Topic {
        guard
            let lastPart: String = path.components(separatedBy: "/").last,
            let string: String = lastPart.components(separatedBy: ".").last,
            let topic: Topic = Topic.init(rawValue: string)
        else { return .unknown }
        
        return topic
    }
}
