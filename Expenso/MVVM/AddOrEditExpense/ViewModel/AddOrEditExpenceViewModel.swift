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
    let transaction: Transaction
    let items: [[AddExpenceFormType]] = [[.Image], [.Category], [.Amount, .Date]]
    init(transaction: Transaction = CoreDataManager.sharedInstance.createObject(classs: Transaction.self)) {
        self.transaction = transaction
    }
    
    var isTransactionSaveEligible: Bool {
        guard let _ = transaction.category, !transaction.amount.isZero else { return false }
        return true
    }
    
    func iconImage() -> UIImage? {
        if let data = transaction.icon {
            return UIImage.init(data: data as Data)
        }
        return placehoderImage
    }
    
    func saveTransaction()  {
        transaction.createdAt = Date() as NSDate
        transaction.date = (transaction.date == nil) ? Date() as NSDate : transaction.date
        CoreDataManager.sharedInstance.saveContext()
    }
}
