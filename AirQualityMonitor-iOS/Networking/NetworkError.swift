//
//  NetworkError.swift
//  AirQualityMonitor-iOS
//
//  Created by Jakub Ziembiński on 15/12/2018.
//  Copyright © 2018 Jakub Ziembiński. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case malformedURL
    case malformedData
    case unknown
}
