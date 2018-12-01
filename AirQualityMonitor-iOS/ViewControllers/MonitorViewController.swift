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
    let dataSource: FeedDataSource
    
    // MARK - Inits
    
    init(dataSource: FeedDataSource = FeedDataSource()) {
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        mainView = MonitorView()
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.delegate = self
        
        setupCollectionView()
    }
    
    // MARK: - Setup
    
    private func setupCollectionView() {
        mainView.collectionView.dataSource = dataSource
        mainView.collectionView.delegate = self
        mainView.collectionView.register(DataCollectionViewCell.self, forCellWithReuseIdentifier: DataCollectionViewCell.identifier)
    }
    
    // MARK: - AirQualityDataMonitor data handling
    
    private func updateView(with message: Float, from topic: Topic) {
        mainView.collectionView.reloadData()
        mainView.setAirQualitySummary(to: dataSource.airQuality)
    }
}

extension MonitorViewController: FeedDataSourceDelegate {
    
    func didReceive(update: Float, from topic: Topic) {
        self.updateView(with: update, from: topic)
    }
}

extension MonitorViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return DataCollectionViewCell.itemSize
    }
}
