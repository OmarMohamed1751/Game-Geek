//
//  GameDetailsVC.swift
//  Game Geek
//
//  Created by Omar Mohamed on 1/8/20.
//  Copyright © 2020 Omar Mohamed. All rights reserved.
//

import UIKit

class GameDetailVC: UIViewController {
    
    //MARK - Outlets
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameNameView: UIView!
    @IBOutlet weak var gamePlatformsCollection: UICollectionView!
    @IBOutlet weak var gameGenreCollection: UICollectionView!
    
    //MARK: - Vars and Lets
    var gameImageString = ""
    var gameNameString = ""
    var platformNameArr = [String]()
    var genreArr = [String]()
    fileprivate let platformCellIdentifier = "PlatformCell"
    fileprivate let genreCellIdentifier = "GenreCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamePlatformsCollection.register(UINib.init(nibName: platformCellIdentifier, bundle: nil), forCellWithReuseIdentifier: platformCellIdentifier)
        gamePlatformsCollection.delegate = self
        gamePlatformsCollection.dataSource = self
        
        gameGenreCollection.register(UINib(nibName: genreCellIdentifier, bundle: nil), forCellWithReuseIdentifier: genreCellIdentifier)
        gameGenreCollection.delegate = self
        gameGenreCollection.dataSource = self
        
        detailsUISetup()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func detailsUISetup() {
        gameName.adjustsFontSizeToFitWidth = true
        gameImage.layer.cornerRadius = 10
        gameNameView.layer.cornerRadius = 10
        gameNameView.layer.borderWidth = 1
        gameNameView.layer.borderColor = #colorLiteral(red: 0, green: 0.7281640172, blue: 0.7614847422, alpha: 1)
        
        gameImage.kf.setImage(with: URL(string: gameImageString), placeholder: UIImage(systemName: "gamecontroller.fill"))
        gameName.text = gameNameString
        
    }
    
    
}
//MARK: - Platforms and Genre collection
extension GameDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == gamePlatformsCollection {
            return platformNameArr.count
        }
        return genreArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == gamePlatformsCollection {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: platformCellIdentifier, for: indexPath) as? PlatformCell else {return UICollectionViewCell()}
            cell.Platform.text = platformNameArr[indexPath.row]
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: genreCellIdentifier, for: indexPath) as? GenreCell else {return UICollectionViewCell()}
            cell.genre.text = genreArr[indexPath.row]
            return cell
        }
        
        
    }
    
}

