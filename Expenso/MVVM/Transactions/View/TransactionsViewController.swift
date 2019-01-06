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
    
    let viewModel = TransactionsViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.frc.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()        
        updateView()        
    }
    
    func updateView(){
        let count = viewModel.frc.sections?.count ?? 0
        tableView.isHidden = count == 0
        errorLabel.isHidden = count > 0
    }
        
    func pushAddOrEditExpenceViewController(transaction: Transaction?){
        let controller = addOrEditExpenceViewController(transaction: transaction)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrasactionCell", for: indexPath) as! TrasactionCell
        let transaction = viewModel.frc.object(at: indexPath)
        cell.set(category: transaction.category, amount: transaction.amount)
        cell.set(imageData: transaction.icon, indexpath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let transaction = viewModel.frc.object(at: indexPath)
        pushAddOrEditExpenceViewController(transaction: transaction)
    }
}

extension TransactionsViewController: NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        updateView()
        viewModel.expenseUpdateHandler?(self, viewModel.month(), viewModel.monthlyExpense())
    }
}
