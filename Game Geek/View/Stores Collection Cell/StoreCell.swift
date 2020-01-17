//
//  StoreCell.swift
//  Game Geek
//
//  Created by Omar Mohamed on 1/17/20.
//  Copyright © 2020 Omar Mohamed. All rights reserved.
//

import UIKit
import Kingfisher

class StoreCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 10
        containerView.layer.borderColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        containerView.layer.borderWidth = 0.5
        storeImage.layer.cornerRadius = storeImage.bounds.height / 2
    }
    
    func attachStores(store: StoreResult) {
        if let storeImage = store.imageBackground {
            self.storeImage.kf.setImage(with: URL(string: storeImage), placeholder: UIImage.init(systemName: "dollarsign.circle.fill"))
        }
        
        if let storeName = store.name {
            self.storeName.text = storeName
        }
    }
}
