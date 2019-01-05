//
//  AddOrEditViewModel.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 04/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit

enum AddExpenceFormType {
    case Image, Category, Amount, Date
}

class AddOrEditExpenceViewModel {
    let items: [[AddExpenceFormType]] = [[.Image], [.Category], [.Amount, .Date]]
    var transaction = CoreDataManager.sharedInstance.createObject(classs: Transaction.self)
    
    var isTransactionSaveEligible: Bool {
        guard let _ = transaction.category, !transaction.amount.isZero else { return false }
        return true
    }
    
    func iconImage() -> UIImage? {
        if let data = transaction.icon {
            return UIImage.init(data: data as Data)
        }
        return UIImage.init(named: "placeholder")
    }
    
    func saveTransaction()  {
        transaction.createdAt = Date() as NSDate
        CoreDataManager.sharedInstance.saveContext()
    }
}
