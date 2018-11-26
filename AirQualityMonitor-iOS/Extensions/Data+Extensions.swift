//
//  Data+Extensions.swift
//  AirQualityMonitor-iOS
//
//  Created by Jakub Ziembiński on 25/11/2018.
//  Copyright © 2018 Jakub Ziembiński. All rights reserved.
//

import UIKit

extension Date {
    
    func toReadableFormat() -> NSAttributedString {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE "
        let dayName: String = dateFormatter.string(from: self)
        
        dateFormatter.dateFormat = "d MMMM"
        let dayWithMonth: String = dateFormatter.string(from: self)
        
        let fullDate: String = dayName.appending(dayWithMonth)
        
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: fullDate)
        attrString.beginEditing()
        attrString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12.0, weight: .regular), range: NSRange(location: 0, length: dayName.count))
        attrString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12.0, weight: .bold), range: NSRange(location: dayName.count, length: dayWithMonth.count))
        attrString.addAttribute(.foregroundColor, value: Style.Color.gray, range: NSRange(location: 0, length: fullDate.count))
        attrString.endEditing()
        
        return attrString
    }
}
