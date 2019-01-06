//
//  ImageCell.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 04/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import UIKit

class TrasactionImageCell: UITableViewCell {
    @IBOutlet private weak var transactionImageView: UIImageView!
    var tapHandler:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup()
    {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(onImageViewTapped(_:)))
        transactionImageView.addGestureRecognizer(tap)
    }

    func setImage(_ image: UIImage?) {
        if let image = image {
            transactionImageView.image = image
        }else{
            transactionImageView.image = placehoderImage
        }
    }
    
    @objc private func onImageViewTapped(_ sender: UITapGestureRecognizer){
        tapHandler?()
    }
}
