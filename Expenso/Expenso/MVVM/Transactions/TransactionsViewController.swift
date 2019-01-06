//
//  TransactionsViewController.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 04/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import UIKit
import CoreData

class TransactionsViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var expenseUpdateHandler: ((TransactionsViewController, String, String) -> Void)?
    var currentIndex = 0
    var date: Date = Date()
    
    private lazy var frc: NSFetchedResultsController<Transaction> = {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let context = CoreDataManager.sharedInstance.workerManagedContext
        let predicate = NSPredicate(format: "date >= %@ && date <= %@", date.startOfMonth() as CVarArg, date.endOfMonth() as CVarArg)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = predicate
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "newCat", cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }        
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()        
        updateView()        
    }
    
    func updateView(){
        let count = frc.sections?.count ?? 0
        tableView.isHidden = count == 0
        errorLabel.isHidden = count > 0
    }
    
    func monthlyExpense() -> String {
        let allMonthlyTransactions = frc.fetchedObjects ?? []
        let allMonthlyExpense = allMonthlyTransactions.reduce(0) { $0 + $1.amount }
        return String(allMonthlyExpense)
    }
    
    func month() -> String {
        let month = date.stringValue(.MMM_YYYY)
        return month
    }
        
    func pushAddOrEditExpenceViewController(transaction: Transaction?){
        let controller = addOrEditExpenceViewController(transaction: transaction)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = frc.sections?[section], let allRows = sectionInfo.objects as? [Transaction] else {return nil}
        let expenseOfTheDay = allRows.reduce(0) { $0 + $1.amount }
        return "\(sectionInfo.name) | Expense: \(expenseOfTheDay)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = frc.sections?.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = frc.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrasactionCell", for: indexPath)
        let transaction = frc.object(at: indexPath)
        cell.textLabel?.text = transaction.category
        cell.detailTextLabel?.text = String(transaction.amount)
//        setImageWith(data: transaction.icon, indexPath: indexPath) { [weak cell] (image, ip) in
//            if indexPath == ip { cell?.imageView?.image = image }
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let transaction = frc.object(at: indexPath)
        pushAddOrEditExpenceViewController(transaction: transaction)
    }
}

extension TransactionsViewController: NSFetchedResultsControllerDelegate{
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//
//        let set = IndexSet.init(integer: sectionIndex)
//
//        switch type {
//        case .insert:
//            tableView.insertSections(set, with: .fade)
//            print("insertSections called index: \(sectionIndex)")
//        case .delete:
//            print("deleteSections called index: \(sectionIndex)")
//            tableView.deleteSections(set, with: .fade)
//        case .update:
//            print("reloadSections called index: \(sectionIndex)")
//            tableView.reloadSections(set, with: .fade)
//        case .move:
//            print("move sectionInfo called index: \(sectionIndex)")
//            tableView.deleteSections(set, with: .fade)
//            tableView.insertSections(set, with: .fade)
//        }
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        guard let newIndexPath = newIndexPath else { return }
//
//        switch type {
//        case .insert:
//            print("insertRows called index: \(newIndexPath)")
//            tableView.insertRows(at: [newIndexPath], with: .fade)
//        case .delete:
//            print("deleteRows called index: \(newIndexPath)")
//            tableView.deleteRows(at: [newIndexPath], with: .fade)
//        case .update:
//            print("reloadRows called index: \(newIndexPath)")
//            tableView.reloadRows(at: [newIndexPath], with: .fade)
//        case .move:
//            print("moveRows called index: \(newIndexPath)")
//            tableView.deleteRows(at: [newIndexPath], with: .fade)
//            tableView.insertRows(at: [newIndexPath], with: .fade)
//        }
//    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
        tableView.reloadData()
        updateView()
        expenseUpdateHandler?(self, month(), monthlyExpense())
    }
}
