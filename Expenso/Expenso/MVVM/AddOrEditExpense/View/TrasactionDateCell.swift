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
        picker.datePickerMode = .dateAndTime
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
    
    func setDate(_ date: Date)  {
        datePicker.minimumDate = aYearAgoFromDate(date)
        datePicker.date = date
        datePicker.maximumDate = aYearAfterFromDate(date)
        textfield.text = date.stringValue
    }
    
    @objc func dateChange(sender: UIDatePicker)  {
        datePicker.date = sender.date
        textfield.text = sender.date.stringValue
        dateCompletionHandler?(sender.date)
    }
}
