//
//  TrasactionDateCell.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 04/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import UIKit

class TrasactionDateCell: UITableViewCell {

    @IBOutlet weak var textfield: UITextField!
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker.init()
        picker.backgroundColor = UIColor.white
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        return picker
    }()
    
    private let toolbar = DoneToolbar()
    var dateCompletionHandler: ((Date) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup(){
        textfield.inputAccessoryView = toolbar
        textfield.inputView = datePicker
        toolbar.doneButtonHandler = {[weak self] (bar: DoneToolbar) -> Void in
            self?.textfield.endEditing(true)
        }
    }
    
    func setDate(_ date: Date = Date())  {
        datePicker.minimumDate = Date().aYearAgo
        datePicker.date = date
        datePicker.maximumDate = Date().aYearAfter
        textfield.text = date.stringValue(.MMM_dd_YYYY)
    }
    
    @objc func dateChange(sender: UIDatePicker)  {
        datePicker.date = sender.date
        textfield.text = sender.date.stringValue(.MMM_dd_YYYY)
        dateCompletionHandler?(sender.date)
    }
}
