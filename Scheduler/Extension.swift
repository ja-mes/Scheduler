//
//  Extension.swift
//  Scheduler
//
//  Created by James Brown on 10/20/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import Foundation

extension String {
    /**
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     
     - Parameter length: A `String`.
     - Parameter trailing: A `String` that will be appended after the truncation.
     
     - Returns: A `String` object.
     */
    func truncate(length: Int, trailing: String = "…") -> String {
        if self.characters.count > length {
            return String(self.characters.prefix(length)) + trailing
        } else {
            return self
        }
    }
}

extension Date {
    func truncateSeconds() -> Date {
        let roundedTime = floor(self.timeIntervalSinceReferenceDate / 60) * 60
        return Date(timeIntervalSinceReferenceDate: roundedTime)
    }
}
