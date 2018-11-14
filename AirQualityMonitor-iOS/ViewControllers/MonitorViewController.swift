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
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.mainView = MonitorView()
        self.view = self.mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

