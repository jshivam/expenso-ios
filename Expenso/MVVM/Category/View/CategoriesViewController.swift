//
//  CategoriesViewController.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 04/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import UIKit

class CategoriesViewController: UITableViewController {

    let viewModel: AllCategoryViewModel
    let completionHandler: (CategoriesViewController, Category) -> Void
    
    init(viewModel: AllCategoryViewModel, completionHandler: @escaping (CategoriesViewController, Category) -> Void) {
        self.viewModel = viewModel
        self.completionHandler = completionHandler
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllCategoryViewModel.allCategory.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = AllCategoryViewModel.allCategory[indexPath.row]
        cell.textLabel?.text = item.rawValue
        if let selectedItem = viewModel.selectedItem{
            cell.accessoryType = selectedItem == item ? .checkmark : .none
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = AllCategoryViewModel.allCategory[indexPath.row]
        completionHandler(self, item)
    }
}
