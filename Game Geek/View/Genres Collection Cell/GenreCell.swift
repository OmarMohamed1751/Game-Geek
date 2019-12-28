//
//  GenreCell.swift
//  Game Geek
//
//  Created by Omar Mohamed on 12/20/19.
//  Copyright © 2019 Omar Mohamed. All rights reserved.
//

import UIKit

class GenreCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var genre: UILabel!
    
    var isCellSelected = Bool()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 10
    }
    
    
    
    func attachTheGenres(result: Result) {
        self.genre.text = result.name
    }
    
}
