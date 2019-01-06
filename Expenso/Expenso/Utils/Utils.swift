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

func aYearAgoFromDate(_ date: Date = Date()) -> Date?{
    let year = calendar.date(byAdding: .year, value: -1, to: date)
    return year
}

func aYearAfterFromDate(_ date: Date = Date()) -> Date?{
    let year = calendar.date(byAdding: .year, value: 1, to: date)
    return year
}

func setImageWith(data: NSData?, indexPath: IndexPath, completion: @escaping (UIImage?, IndexPath) -> Void) -> Void
{
    guard let data = data else {
        completion(UIImage.init(named: "placeholder"), indexPath)
        return
    }
    
    DispatchQueue.global(qos: .background).async {
        let image = UIImage(data: data as Data)
        DispatchQueue.main.async {
            completion(image, indexPath)
        }
    }
}

extension Date{
    var stringValue: String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "dd/MM/YYYY HH:mm"
        return formatter.string(from: self)
    }
    
    var readableDate: String{
        let formatter = DateFormatter.init()
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: self)
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
