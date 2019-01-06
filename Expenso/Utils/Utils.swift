//
//  DateUtils.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 05/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit

let calendar = Calendar.current
let rootTabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController
let placehoderImage = UIImage.init(named: "placeholder")

func setImageWith(data: NSData?, indexPath: IndexPath, completion: @escaping (UIImage?, IndexPath) -> Void) -> Void
{
    guard let data = data else {
        completion(placehoderImage, indexPath)
        return
    }
    
    DispatchQueue.global(qos: .background).async {
        let image = UIImage(data: data as Data)
        DispatchQueue.main.async {
            completion(image, indexPath)
        }
    }
}

func CenteredOrigin(x: CGFloat, y: CGFloat) -> CGFloat {
    return floor((x - y)/2.0)
}

enum DateFormat: String {
    case MMM_dd_YYYY = "MMM dd YYYY"
    case MMM_dd = "MMM dd"
    case MMM_YYYY = "MMM YYYY"
}

extension Date{
    
    var aYearAgo: Date {
        let year = Calendar.current.date(byAdding: .year, value: -1, to: self)
        return year!
    }
    
    var aYearAfter: Date {
        let year = calendar.date(byAdding: .year, value: 1, to: self)
        return year!
    }
    
    func stringValue(_ format: DateFormat) -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = format.rawValue
        if let fancyDate = fancyDateString(){
            return fancyDate
        }
        return formatter.string(from: self)
    }
    
    func month(after: Int) -> Date {
        let month = calendar.date(byAdding: .month, value: after, to: self)
        return month!
    }
    
    func day(after: Int) -> Date {
        let day = calendar.date(byAdding: .day, value: after, to: self)
        return day!
    }
    
    private func fancyDateString() -> String? {
        let currentDate = Date()
        if self.isOfSameDay(date: currentDate.day(after: 0)) {
            return "Today"
        }else if self.isOfSameDay(date: currentDate.day(after: -1)) {
            return "Yesterday"
        }
        return nil
    }
    
    func isOfSameDay(date: Date) -> Bool {
        let date1 = Calendar.current.date(from: Calendar.current.dateComponents([.day, .year, .month], from: self))!
        let date2 = Calendar.current.date(from: Calendar.current.dateComponents([.day, .year, .month], from: date))!
        return date1 == date2
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

extension UIImage{
    func resizeImage(newWidth: CGFloat = 64) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
