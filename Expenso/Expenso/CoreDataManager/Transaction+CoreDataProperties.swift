//
//  Transaction+CoreDataProperties.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 05/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var icon: NSData?
    @NSManaged public var category: String?
    @NSManaged public var details: String?
    @NSManaged public var amount: Double
    @NSManaged public var date: NSDate?
    @NSManaged public var createdAt: NSDate?
}

//extension Transaction: NSCopying
//{
//    public func copy(with zone: NSZone? = nil) -> Any {
//        let transaction = CoreDataManager.sharedInstance.createObject(classs: Transaction.self)
//        transaction.icon = self.icon
//        transaction.category = self.category
//        transaction.details = self.details
//        transaction.date = self.date
//        transaction.createdAt = self.createdAt
//        return transaction
//    }
//}
