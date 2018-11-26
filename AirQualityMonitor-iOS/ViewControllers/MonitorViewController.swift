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
    
    private var latestMessage: (Topic, Float)?
    private var topics: [Topic] = [.temperature, .pm2dot5, .humidity, .pm10, .pressure]
    private var measurements: [Topic: Float?] = [:]
    
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.mainView = MonitorView()
        self.view = self.mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        airQualityDataProvider.delegate = self
        
        self.setupCollectionView()
        self.setupData()
    }
    
    // MARK: - Setup
    
    private func setupCollectionView() {
        self.mainView.collectionView.dataSource = self
        self.mainView.collectionView.delegate = self
        self.mainView.collectionView.register(DataCollectionViewCell.self, forCellWithReuseIdentifier: DataCollectionViewCell.identifier)
    }
    
    private func setupData() {
        topics.forEach { self.measurements[$0] = nil }
    }
    
    // MARK: - AirQualityDataMonitor data handling
    
    private func updateView(with message: String, from topic: Topic) {
        if let value: Float = Float(message) {
            self.measurements[topic] = value
            self.mainView.collectionView.reloadData()
            self.calculateAirQuality()
        }
    }
    
    func calculateAirQuality() {
        var airQuality: AirQuality = .unknown
        
        if let pm2dot5: Float = self.measurements[.pm2dot5] as? Float, let pm10: Float = self.measurements[.pm10] as? Float {
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
        return self.topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell: DataCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: DataCollectionViewCell.identifier, for: indexPath) as? DataCollectionViewCell
        else { fatalError() }
        
        if let topic = cell.topic {
            if let value = self.measurements[topic] as? Float {
                cell.set(value: value)
            }
        } else {
            cell.setup(for: topics[indexPath.item])
        }
        
        return cell
    }
}

extension MonitorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return DataCollectionViewCell.itemSize
    }
    
//    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
}
