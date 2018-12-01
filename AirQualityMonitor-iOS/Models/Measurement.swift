//
//  Measurement.swift
//  AirQualityMonitor-iOS
//
//  Created by Jakub Ziembiński on 25/11/2018.
//  Copyright © 2018 Jakub Ziembiński. All rights reserved.
//

import Foundation

final class Measurement {
    let topic: Topic
    
    private var values: [Float] = []
    
    var value: Float? {
        if values.isEmpty { return nil }
        var x: Float = 0.0
        for v in values { x += v }
        return x / Float(values.count)
    }
    
    // MARK: - Init
    
    init(topic: Topic) {
        self.topic = topic
    }
    
    // MARK: - Updating data
    
    func set(update: Float) {
        if values.count == 5 { values.remove(at: 0) }
        values.append(update)
    }
}
