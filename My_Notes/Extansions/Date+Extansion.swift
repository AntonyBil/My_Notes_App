//
//  Date+Extansion.swift
//  My_Notes
//
//  Created by apple on 07.06.2023.
//

import Foundation

extension Date {
    
    func format() -> String {
        
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(self) {
            formatter.dateFormat = "h:mm a"
        } else {
            formatter.dateFormat = "dd/MM/yy"
        }
        
        return formatter.string(from: self)
    }
}
