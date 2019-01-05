//
//  AddOrEditViewModel.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 04/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import Foundation

enum AddExpenceFormType {
    case Image, Category, Amount, Date
}

class AddOrEditExpenceViewModel {
    let items: [[AddExpenceFormType]] = [[.Image], [.Category], [.Amount, .Date]]
}
