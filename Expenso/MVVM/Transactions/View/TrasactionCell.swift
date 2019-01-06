//
//  TrasactionCell.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 07/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import UIKit

class TrasactionCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.clipsToBounds = true
        iconImageView.layer.borderColor = UIColor.black.cgColor
        iconImageView.layer.borderWidth = 1.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.layer.cornerRadius = self.iconImageView.bounds.height/2.0
    }
    
    func set(imageData: NSData?, indexpath: IndexPath){
        iconImageView.image = placehoderImage
        setImageWith(data: imageData, indexPath: indexpath) {[weak self] (image, ip) in
            guard let __self = self else {return}
            if indexpath == ip{
                __self.iconImageView.image = image
            }
            __self.layoutIfNeeded()
            __self.setNeedsLayout()
        }
        layoutIfNeeded()
        setNeedsLayout()
    }
    
    func set(category: String?, amount: Double){
        self.categoryLabel.text = category
        self.amountLabel.text = String(amount)
        self.setNeedsLayout()
    }
}
