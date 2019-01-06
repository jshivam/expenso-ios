//
//  Transaction+CoreDataProperties.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 06/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var date: NSDate?
    @NSManaged public var details: String?
    @NSManaged public var icon: NSData?
    
    @objc public var newCat: String?{
        let date = self.date as Date?
        return date?.readableDate
    }
}
