//
//  DateUtils.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 05/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import Foundation

let calendar = Calendar.current

func aYearAgoFromDate(_ date: Date = Date()) -> Date?{
    let year = calendar.date(byAdding: .year, value: -1, to: date)
    return year
}

func aYearAfterFromDate(_ date: Date = Date()) -> Date?{
    let year = calendar.date(byAdding: .year, value: 1, to: date)
    return year
}

extension Date{
    var stringValue: String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "dd/MM/YYYY HH:mm"
        return formatter.string(from: self)
    }
}
