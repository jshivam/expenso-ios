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

    @IBOutlet weak var tableView: UITableView!
    fileprivate lazy var frc: NSFetchedResultsController<Transaction> = {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let context = CoreDataManager.sharedInstance.workerManagedContext
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "category", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
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
        
        let save = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = save
    }
    
    @objc func addTapped() {
        pushAddOrEditExpenceViewController(transaction: nil)
    }
    
    func pushAddOrEditExpenceViewController(transaction: Transaction?)
    {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AddOrEditExpenceViewController") as!AddOrEditExpenceViewController
        if let transaction = transaction, let managedObject = CoreDataManager.sharedInstance.networkManagedContext.object(with: transaction.objectID) as? Transaction  {
            let viewModel = AddOrEditExpenceViewModel.init(transaction: managedObject)
            controller.viewModel = viewModel
        }else{
            let viewModel = AddOrEditExpenceViewModel()
            controller.viewModel = viewModel
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return frc.sections?.count ?? 0
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
        setImageWith(data: transaction.icon, indexPath: indexPath) { [weak cell] (image, ip) in
//            if indexPath == ip { cell?.imageView?.image = image }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = frc.object(at: indexPath)
        pushAddOrEditExpenceViewController(transaction: transaction)
    }
}

extension TransactionsViewController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            let set = IndexSet.init(integer: sectionIndex)
            tableView.insertSections(set, with: .fade)
        case .delete:
            let set = IndexSet.init(integer: sectionIndex)
            tableView.deleteSections(set, with: .fade)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let newIndexPath = newIndexPath else { return }
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            tableView.deleteRows(at: [newIndexPath], with: .fade)
        case .update:
            tableView.reloadRows(at: [newIndexPath], with: .fade)
        case .move:
            tableView.deleteRows(at: [newIndexPath], with: .fade)
            tableView.insertRows(at: [newIndexPath], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
