//
//  DataCollectionViewCell
//  AirQualityMonitor-iOS
//
//  Created by Jakub Ziembiński on 21/11/2018.
//  Copyright © 2018 Jakub Ziembiński. All rights reserved.
//

import UIKit

final class DataCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "DataTableViewCell"
    static let itemSize: CGSize = CGSize(width: 163, height: 144)
    
    // MARK: - Subviews
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = Style.Color.gray
        label.font = .systemFont(ofSize: 8.0, weight: .bold)
        label.textAlignment = .left
        
        return label
    }()
    
    private let dataLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = Style.Color.darkGray
        label.font = .systemFont(ofSize: 58.0, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()
    
    private let unitLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = Style.Color.gray
        label.font = .systemFont(ofSize: 12.0, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    private let loader: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    private(set) var topic: Topic?
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layoutTitleLabel()
        self.layoutDataLabel()
        self.layoutUnitLabel()
        self.layoutLoader()
        
        self.loader.startAnimating()
        self.loader.hidesWhenStopped = true
        
        self.visualSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func layoutTitleLabel() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.titleLabel)
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8.0)
        ])
    }
    
    private func layoutDataLabel() {
        self.dataLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.dataLabel)
        
        NSLayoutConstraint.activate([
            self.dataLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 8.0),
            self.dataLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.dataLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.dataLabel.widthAnchor.constraint(equalToConstant: DataCollectionViewCell.itemSize.width)
            
        ])
    }
    
    private func layoutUnitLabel() {
        self.unitLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.unitLabel)
        
        NSLayoutConstraint.activate([
            self.unitLabel.topAnchor.constraint(equalTo: self.dataLabel.bottomAnchor, constant: 17.0),
            self.unitLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0),
            self.unitLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16.0),
            self.unitLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16.0)
        ])
    }
    
    private func layoutLoader() {
        self.loader.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.loader)
        
        NSLayoutConstraint.activate([
            self.loader.topAnchor.constraint(equalTo: self.dataLabel.topAnchor),
            self.loader.leadingAnchor.constraint(equalTo: self.dataLabel.leadingAnchor),
            self.loader.trailingAnchor.constraint(equalTo: self.dataLabel.trailingAnchor),
            self.loader.bottomAnchor.constraint(equalTo: self.dataLabel.bottomAnchor),
            self.loader.widthAnchor.constraint(equalToConstant: DataCollectionViewCell.itemSize.width),
            self.loader.heightAnchor.constraint(equalToConstant: 69.5)
        ])
    }
    
    private func visualSetup() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 8.0
        
        self.backgroundColor = .white
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.1
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    // MARK: - Setup
    
    func setup(for topic: Topic) {
        self.topic = topic
        self.unitLabel.text = topic.unit
        self.titleLabel.text = topic.readableName
    }
    
    func set(value: Float?) {
        guard let value = value else { return }
        self.dataLabel.text = String("\(value)".prefix(4))
        self.unitLabel.text = self.topic?.unit
        self.titleLabel.text = self.topic?.readableName
        self.loader.stopAnimating()
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.dataLabel.text = nil
        self.unitLabel.text = nil
        self.titleLabel.text = nil
    }
}
