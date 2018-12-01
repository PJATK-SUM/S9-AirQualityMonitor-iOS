//
//  Array+Extrensions.swift
//  AirQualityMonitor-iOS
//
//  Created by Jakub Ziembiński on 01/12/2018.
//  Copyright © 2018 Jakub Ziembiński. All rights reserved.
//

import Foundation

extension Array where Element: Measurement {
    func getFirst(for topic: Topic) -> Measurement? {
        return self.first(where: { $0.topic == topic })
    }
}
