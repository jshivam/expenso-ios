//
//  AddOrEditExpenceViewController.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 04/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import UIKit

class AddOrEditExpenceViewController: UITableViewController {

    let viewModel = AddOrEditExpenceViewModel()
    
    var cat: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 44.0; // set to whatever your "average" cell height is
    }

    // MARK: - Table view data source

//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = viewModel.items[indexPath.section][indexPath.row]
        switch item {
        case .Image:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrasactionImageCell", for: indexPath)
            return cell
        case .Category:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrasactionCategoryCell", for: indexPath)
            cell.textLabel?.text = "Category"
            cell.detailTextLabel?.text = cat?.rawValue
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = viewModel.items[indexPath.section][indexPath.row]
        switch item {
        case .Category:
            let vm = AllCategoryViewModel.init()
            vm.selectedItem = cat
            let vc = CategoriesViewController.init(viewModel: vm) { [weak self] (controller, category) in
                controller.navigationController?.popViewController(animated: true)
                self?.cat = category
                self?.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
