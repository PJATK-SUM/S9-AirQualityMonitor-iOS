//
//  RemoteReading.swift
//  AirQualityMonitor-iOS
//
//  Created by Jakub Ziembiński on 09/12/2018.
//  Copyright © 2018 Jakub Ziembiński. All rights reserved.
//

import Foundation

typealias RemoteReadings = [RemoteReading]

struct RemoteReading: Codable {
    let value: String
    let feedKey: String
    
    enum CodingKeys: String, CodingKey {
        case value = "value"
        case feedKey = "feed_key"
    }
}
