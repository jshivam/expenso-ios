//
//  Routers.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 06/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit

let storyboard = UIStoryboard(name: "Main", bundle: nil)


func addOrEditExpenceViewController(transaction: Transaction? = nil) -> AddOrEditExpenceViewController
{
    let controller = storyboard.instantiateViewController(withIdentifier: "AddOrEditExpenceViewController") as! AddOrEditExpenceViewController
    if let transaction = transaction, let managedObject = CoreDataManager.sharedInstance.networkManagedContext.object(with: transaction.objectID) as? Transaction  {
        let viewModel = AddOrEditExpenceViewModel.init(transaction: managedObject)
        controller.viewModel = viewModel
    }else{
        let viewModel = AddOrEditExpenceViewModel()
        controller.viewModel = viewModel
    }
    return controller
}
