//
//  Extensions.swift
//  NewsApp
//
//  Created by Esraa Hamed on 24/04/2022.
//

import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

extension TimeInterval {
    public var minutes: Int {
        return (Int(self) / 60 ) % 60
    }
}
