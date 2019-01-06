//
//  TextFieldCell.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 04/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import UIKit

class TrasactionAmountCell: UITableViewCell {

    @IBOutlet weak var textfield: UITextField!
    
    private let toolbar = DoneToolbar()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup(){
        textfield.inputAccessoryView = toolbar
        toolbar.doneButtonHandler = {[weak self] (bar: DoneToolbar) -> Void in
            self?.textfield.endEditing(true)
        }
    }
}
