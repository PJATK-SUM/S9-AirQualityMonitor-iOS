//
//  MonitorViewController.swift
//  AirQualityMonitor-iOS
//
//  Created by Jakub Ziembiński on 14/11/2018.
//  Copyright © 2018 Jakub Ziembiński. All rights reserved.
//

import UIKit

class MonitorViewController: UIViewController {
    
    // MARK: - Properties
    
    var mainView: MonitorView!
    var airQualityDataProvider: AirQualityDataProvider = AirQualityDataProvider()
    
    private var measurements: [Measurement] = [Measurement.init(topic: .pressure, value: 1041), Measurement.init(topic: .temperature, value: 21.5)]
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.mainView = MonitorView()
        self.view = self.mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        airQualityDataProvider.delegate = self
        
        self.mainView.collectionView.dataSource = self
        self.mainView.collectionView.delegate = self
        self.mainView.collectionView.register(DataCollectionViewCell.self, forCellWithReuseIdentifier: DataCollectionViewCell.identifier)
    }
    
    // MARK: - AirQualityDataMonitor data handling
    
    private func updateView(with message: String, from topic: Topic) {
        if let value: Float = Float(message) {
            self.measurements.append(Measurement(topic: topic, value: value))
            self.mainView.collectionView.reloadData()
        }
    }
    
    func calculateAirQuality() {
        var airQuality: AirQuality = .unknown
        
        if let pm2dot5: Measurement = self.measurements.first(where: { $0.topic == .pm2dot5 }) {
            let value: Float = pm2dot5.value
            if value < 10.0 {
                airQuality = .veryGood
            } else if value < 25.0 {
                airQuality = .fine
            } else if value < 50.0 {
                airQuality = .mediocre
            } else if value < 80.0 {
                airQuality = .bad
            } else if value >= 80.0 {
                airQuality = .terrible
            }
            
            self.mainView.setAirQualitySummary(to: airQuality)
        }
    }
}

extension MonitorViewController: AirQualityDataProviderDelegate {
    func didConnect() {
        self.airQualityDataProvider.subscribe(to: .all)
    }
    
    func didSubscribe(to topic: Topic) {
//        self.topics.append(topic)
    }
    
    func didUnsubscribe(from topic: Topic) {
//        self.topics = topics.filter { $0.rawValue != topic.rawValue }
    }
    
    func didReceiveMessage(_ message: String?, topic: Topic) {
        if let message = message { self.updateView(with: message, from: topic) }
    }
}

extension MonitorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.measurements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell: DataCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: DataCollectionViewCell.identifier, for: indexPath) as? DataCollectionViewCell
        else { fatalError() }
        
        cell.setup(for: measurements[indexPath.item])
        
        return cell
    }
}

extension MonitorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return DataCollectionViewCell.itemSize
    }
}
