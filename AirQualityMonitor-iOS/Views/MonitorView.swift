//
//  MonitorView.swift
//  AirQualityMonitor-iOS
//
//  Created by Jakub Ziembiński on 14/11/2018.
//  Copyright © 2018 Jakub Ziembiński. All rights reserved.
//

import UIKit

final class MonitorView: UIView {
    
    // MARK: - Subviews
    
    private(set) lazy var dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.attributedText = Date().toReadableFormat()
        label.textAlignment = .center
        
        return label
    }()
    
    private(set) lazy var summaryLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.textColor = Style.Color.darkGray
        label.font = .systemFont(ofSize: 42.0, weight: .bold)
        
        return label
    }()
    
    private(set) lazy var summaryCaptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.textColor = Style.Color.lightGray
        label.font = .systemFont(ofSize: 8.0, weight: .bold)
        label.text = "Current air quality"
        
        return label
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: DataCollectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.layer.masksToBounds = false
        
        return collectionView
    }()
    
    private let loader: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    // MARK: - Inits
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        
        layoutDateLabel()
        layoutSummaryLabel()
        layoutSummaryCaptionLabel()
        layoutCollectionView()
        layoutLoader()
        
        loader.startAnimating()
        loader.hidesWhenStopped = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func layoutDateLabel() {
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.dateLabel)
        
        NSLayoutConstraint.activate([
            self.dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.dateLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            self.dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            self.dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0)
        ])
    }
    
    private func layoutSummaryLabel() {
        self.summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.summaryLabel)
        
        NSLayoutConstraint.activate([
            self.summaryLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.summaryLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 16.0),
            self.summaryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            self.summaryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0)
        ])
    }
    
    private func layoutSummaryCaptionLabel() {
        self.summaryCaptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.summaryCaptionLabel)
        
        NSLayoutConstraint.activate([
            self.summaryCaptionLabel.centerXAnchor.constraint(equalTo: self.summaryLabel.centerXAnchor),
            self.summaryCaptionLabel.topAnchor.constraint(equalTo: self.summaryLabel.bottomAnchor),
            self.summaryCaptionLabel.leadingAnchor.constraint(equalTo: self.summaryLabel.leadingAnchor),
            self.summaryCaptionLabel.trailingAnchor.constraint(equalTo: self.summaryLabel.trailingAnchor)
        ])
    }
    
    private func layoutCollectionView() {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.summaryCaptionLabel.bottomAnchor, constant: 36.0),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 32.0)
        ])
    }
    
    private func layoutLoader() {
        self.loader.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.loader)
        
        NSLayoutConstraint.activate([
            self.loader.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 16.0),
            self.loader.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.loader.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.loader.bottomAnchor.constraint(equalTo: self.summaryCaptionLabel.topAnchor),
            self.loader.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
    func setAirQualitySummary(to airQuality: AirQuality) {
        self.summaryLabel.text = airQuality.rawValue
        self.loader.stopAnimating()
    }
}

enum AirQuality: String {
    case terrible = "Terrible"
    case bad = "Bad"
    case mediocre = "Mediocre"
    case fine = "Fine"
    case veryGood = "Very good"
    case unknown = "Computing..."
}
