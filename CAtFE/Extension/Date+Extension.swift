//
//  Date+Extension.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/19.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

extension Date {

    func timeAgoSinceDate() -> String {

        // From Time
        let fromDate = self

        // To Time
        let toDate = Date()

        // Estimation
        // Year
//        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0 {
//
//            return interval == 1 ? "\(interval)" + " " + "年前" : "\(interval)" + " " + "年前"
//        }

        // Month
//        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0 {
//
//            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
//        }

        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0 {
            if interval > 7 {
                return "\(fromDate))"
            } else {
                return interval == 1 ? "\(interval)" + " " + "天" : "\(interval)" + " " + "天"
            }
        }

        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "小時" : "\(interval)" + " " + "小時"
        }

        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "分鐘" : "\(interval)" + " " + "分鐘"
        }

        return "a moment ago"
    }
}
