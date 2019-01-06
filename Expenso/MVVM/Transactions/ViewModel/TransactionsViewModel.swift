//
//  TransactionsViewModel.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 07/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import UIKit
import CoreData

class TransactionsViewModel {
    
    var currentIndex = 0
    var date: Date = Date()
    var expenseUpdateHandler: ((TransactionsViewController, String, String) -> Void)?
    let context = CoreDataManager.sharedInstance.workerManagedContext

    lazy var frc: NSFetchedResultsController<Transaction> = {
        let fetchRequest = self.fetchRequest
        let context = self.context
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "newCat", cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        return fetchedResultsController
    }()
    
    lazy var fetchRequest: NSFetchRequest<Transaction> = {
        let predicate = NSPredicate(format: "date >= %@ && date <= %@", date.startOfMonth() as CVarArg, date.endOfMonth() as CVarArg)
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = predicate
        return fetchRequest
    }()
    
    func monthlyExpense() -> String {
        let allMonthlyTransactions = transactionsForTheMonth()
        let allMonthlyExpense = allMonthlyTransactions.reduce(0) { $0 + $1.amount }
        return String(allMonthlyExpense)
    }
    
    func transactionsForTheMonth() -> [Transaction] {
        let allMonthlyTransactions = frc.fetchedObjects ?? []
        return allMonthlyTransactions
    }
    
    func month() -> String {
        let month = date.stringValue(.MMM_YYYY)
        return month
    }
    
    func title(section: Int) -> String?
    {
        guard let sectionInfo = frc.sections?[section], let allRows = sectionInfo.objects as? [Transaction] else {return nil}
        let expenseOfTheDay = allRows.reduce(0) { $0 + $1.amount }
        return "\(sectionInfo.name) | Expense: \(expenseOfTheDay)"
    }
    
    func numberOfSections() -> Int {
        let count = frc.sections?.count ?? 0
        return count
    }
    
    func numberOfRows(section: Int) -> Int {
        let sectionInfo = frc.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }
    
    func heightForRow() -> CGFloat {
        return 48
    }
}
