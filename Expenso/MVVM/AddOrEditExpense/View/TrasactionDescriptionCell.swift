//
//  TrasactionDescriptionCell.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 04/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import UIKit

class TrasactionDescriptionCell: UITableViewCell {

    @IBOutlet private weak var textView: UITextView!
    var keyboardDismissHandler: ((String?) -> Void)?

    private let placeholder = "Description"
    private let toolbar = DoneToolbar()

    override func awakeFromNib() {
        super.awakeFromNib()

        textView.delegate = self
        
        textView.inputAccessoryView = toolbar
        toolbar.doneButtonHandler = {[weak self] (bar: DoneToolbar) -> Void in
            self?.textView.endEditing(true)
        }
    }
    
    func setText(_ text: String?){
        
        guard let string = text, !string.isEmpty  else {
            placeholderSetup(true)
            return
        }
        textView.text = string
        placeholderSetup(false, text: string)
    }
    
    func placeholderSetup(_ isPlaceholder: Bool, text: String? = nil) {
        textView.textColor = isPlaceholder ? .lightGray : .black
        textView.text = isPlaceholder ? placeholder : text
    }
}

extension TrasactionDescriptionCell: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
        let text = textView.text == placeholder ? nil : textView.text
        keyboardDismissHandler?(text)
    }
}
