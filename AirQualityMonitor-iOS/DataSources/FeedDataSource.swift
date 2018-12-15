//
//  FeedDataSource.swift
//  AirQualityMonitor-iOS
//
//  Created by Jakub Ziembiński on 01/12/2018.
//  Copyright © 2018 Jakub Ziembiński. All rights reserved.
//

import UIKit

protocol FeedDataSourceDelegate: class {
    func didReceiveUpdate()
    func didReceive(error: Error)
    func didDisconnect()
    func didConnect()
}

protocol FeedDataSourceProtocol: class {
    var measurements: [Measurement] { get }
    var airQuality: AirQuality { get }
    
    var delegate: FeedDataSourceDelegate? { get set }
}

final class FeedDataSource: NSObject, FeedDataSourceProtocol {
    
    // MARK: - Properties
    
    var dataProvider: AirQualityDataProviderProtocol
    
    var delegate: FeedDataSourceDelegate?
    
    private(set) var measurements: [Measurement] = []
    
    var airQuality: AirQuality {
        var airQuality: AirQuality = .unknown
        
        if
            let pm2dot5: Float = self.measurements.getFirst(for: .pm2dot5)?.value,
            let pm10: Float = self.measurements.getFirst(for: .pm10)?.value
        {
            let value: Float = pm2dot5 + pm10
            if value < 20.0 {
                airQuality = .veryGood
            } else if value < 50.0 {
                airQuality = .fine
            } else if value < 100.0 {
                airQuality = .mediocre
            } else if value < 160.0 {
                airQuality = .bad
            } else if value >= 160.0 {
                airQuality = .terrible
            }
        }
        
        return airQuality
    }
    
    // MARK: - Init
    
    init(dataProvider: AirQualityDataProviderProtocol = AirQualityDataProvider()) {
        self.dataProvider = dataProvider
        
        super.init()
        
        self.setupMeasurements()
        self.setupDataProvider()
    }
    
    // MARK: - Setup
    
    private func setupMeasurements() {
        Topic.all.forEach { self.measurements.append(Measurement(topic: $0)) }
    }
    
    private func setupDataProvider() {
        self.dataProvider.delegate = self
        self.dataProvider.start()
    }
    
    // MARK: - Connection
    
    func reconnect() {
        self.dataProvider.stop()
        self.dataProvider.start()
    }
}

extension FeedDataSource: AirQualityDataProviderDelegate {
    func didConnect() {
        self.dataProvider.subscribe(to: .allHash)
        self.delegate?.didConnect()
    }
    
    func didDisconnect() {
        self.delegate?.didDisconnect()
    }
    
    func didReceive(update value: Float, for topic: Topic) {
        measurements.getFirst(for: topic)?.set(update: value)
        self.delegate?.didReceiveUpdate()
    }
    
    func didReceive(initalValues values: [Float], for topic: Topic) {
        measurements.getFirst(for: topic)?.set(initalValues: values)
        self.delegate?.didReceiveUpdate()
    }
    
    func didReceive(error: Error) {
        self.delegate?.didReceive(error: error)
    }
}

extension FeedDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.measurements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell: DataCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: DataCollectionViewCell.identifier, for: indexPath) as? DataCollectionViewCell
            else { fatalError() }
        
        let measurement: Measurement = measurements[indexPath.item]
        cell.setup(for: measurement.topic)
        if let value = measurement.value { cell.set(value: value) }
        
        return cell
    }
}
