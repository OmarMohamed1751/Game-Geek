//
//  GameCell.swift
//  Game Geek
//
//  Created by Omar Mohamed on 12/20/19.
//  Copyright © 2019 Omar Mohamed. All rights reserved.
//

import UIKit
import Kingfisher

class GameCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameRate: UILabel!
    @IBOutlet weak var relaseDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.cornerRadius = 10
        gameImage.layer.cornerRadius = 10
    }
    
    func attachGames(game: GameResult) {
        if let gameImage = game.backgroundImage {
            self.gameImage.kf.setImage(with: URL(string: gameImage), placeholder: UIImage.init(systemName: "gamecontroller.fill"))
        }
        
        if let gameName = game.name {
            self.gameName.text = gameName
        }
        
        if let gameRate = game.rating {
            self.gameRate.text = "\(gameRate)"
        }
        
        if let relaseDate = game.released {
            self.relaseDate.text = "\(relaseDate)"
        }
    }
    
}
