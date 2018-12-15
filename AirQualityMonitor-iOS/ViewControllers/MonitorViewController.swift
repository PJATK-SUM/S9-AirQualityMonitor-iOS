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
        setupConnectionRetryButton()
    }
    
    // MARK: - Setup
    
    private func setupCollectionView() {
        mainView.collectionView.dataSource = dataSource
        mainView.collectionView.delegate = self
        mainView.collectionView.register(DataCollectionViewCell.self, forCellWithReuseIdentifier: DataCollectionViewCell.identifier)
    }
    
    private func setupConnectionRetryButton() {
        mainView.connectionStatusAlert.retryButton.addTarget(self, action: #selector(retryConnection), for: .touchUpInside)
    }
    
    @objc func retryConnection() {
        self.dataSource.reconnect()
    }
    
    // MARK: - AirQualityDataMonitor data handling
    
    private func updateView() {
        mainView.collectionView.reloadData()
        mainView.setAirQualitySummary(to: dataSource.airQuality)
    }
    
    private func handleError(_ error: Error) {
        guard let _ = error as? NetworkError else {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Reconnect", style: .default, handler: { [weak self] (_) in
                self?.dataSource.reconnect()
            }))
            present(alert, animated: true, completion: nil)
            return
        }
    }
}

extension MonitorViewController: FeedDataSourceDelegate {
    
    func didReceiveUpdate() {
        DispatchQueue.main.async { self.updateView() }
    }
    
    func didDisconnect() {
        mainView.connectionAlert(isShown: true)
    }
    
    func didConnect() {
        mainView.connectionAlert(isShown: false)
    }
    
    func didReceive(error: Error) {
        self.handleError(error)
    }
}

extension MonitorViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return DataCollectionViewCell.itemSize
    }
}
