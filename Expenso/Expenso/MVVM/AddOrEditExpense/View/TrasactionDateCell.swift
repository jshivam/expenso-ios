//
//  TrasactionDateCell.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 04/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import UIKit

class TrasactionDateCell: UITableViewCell {

    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker.init()
        picker.backgroundColor = UIColor.white
        picker.datePickerMode = .dateAndTime
        picker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        return picker
    }()
    
    var date: (min: Date?, current: Date, max: Date?)?{
        didSet{
            datePicker.minimumDate = date?.min
            datePicker.date = date?.current ?? Date()
            datePicker.maximumDate = date?.max
        }
    }
        
//    override func setup(){
//        super.setup()
//        titleLabel.text = "Date"
//        textfield.inputView = datePicker
//    }
    
    @objc func dateChange(sender: UIDatePicker)  {
        datePicker.date = sender.date
//        textfield.text = sender.date.dateString
    }
}
