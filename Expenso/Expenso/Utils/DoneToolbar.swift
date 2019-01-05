//
//  DoneToolbar.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 04/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import UIKit

class DoneToolbar: UIToolbar {

    var doneButtonHandler: ((DoneToolbar) -> Void)?
    
    override init(frame: CGRect) {
        let rect = CGRect.init(x: 0, y: 0, width: 0, height: 44)
        super.init(frame: rect)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup()  {
        tintColor = UIColor.lightGray
        barStyle = .default
        let done = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(toolBarDoneButtonPressed))
        setItems([done], animated: false)
    }
    
    @objc func toolBarDoneButtonPressed()  {
        doneButtonHandler?(self)
    }
}
