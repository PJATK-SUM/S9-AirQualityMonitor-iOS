//
//  ConnectionStatusAlert.swift
//  AirQualityMonitor-iOS
//
//  Created by Jakub Ziembiński on 09/12/2018.
//  Copyright © 2018 Jakub Ziembiński. All rights reserved.
//

import UIKit

final class ConnectionStatusAlert: UIView {
    
    // MARK: - Properties
    
    private(set) var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "No connection. Check your connection or try again later."
        label.textAlignment = .left
        label.textColor = .white
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 11.0)
        
        return label
    }()
    
    private(set) var retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 11.0, weight: .bold)
        
        return button
    }()
    
    // MARK: - Inits
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        layoutMessageLabel()
        layoutRetryButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupView() {
        self.backgroundColor = .red
    }
    
    // MARK: - Layout
    
    func layoutMessageLabel() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2.0),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.0)
        ])
    }
    
    func layoutRetryButton() {
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            retryButton.topAnchor.constraint(equalTo: messageLabel.topAnchor),
            retryButton.leadingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 8.0),
            retryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
            retryButton.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor)
        ])
    }
}
