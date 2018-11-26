//
//  DataCollectionViewLayout.swift
//  AirQualityMonitor-iOS
//
//  Created by Jakub Ziembiński on 25/11/2018.
//  Copyright © 2018 Jakub Ziembiński. All rights reserved.
//

import UIKit

final class DataCollectionViewLayout: UICollectionViewFlowLayout {
    
    // MARK: - Init
    
    override init() {
        super.init()
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setup() {
        self.itemSize = DataCollectionViewCell.itemSize
        self.estimatedItemSize = DataCollectionViewCell.itemSize
        
        self.scrollDirection = .vertical
        
        self.sectionInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        self.minimumInteritemSpacing = 17.0
        self.minimumLineSpacing = 16.0
    }
}
