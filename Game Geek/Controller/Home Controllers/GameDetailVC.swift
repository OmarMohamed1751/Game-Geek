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
    @IBOutlet weak var gameDescriptionTextView: UITextView!
    @IBOutlet weak var screenShotsCollection: UICollectionView!
    
    //MARK: - Vars and Lets
    var gameImageString = ""
    var gameNameString = ""
    var platformNameArr = [String]()
    var genreArr = [String]()
    var screenshotArr = [ShortScreenshot]()
    
    fileprivate let platformCellIdentifier = "PlatformCell"
    fileprivate let genreCellIdentifier = "GenreCell"
    fileprivate let screenShotCellIdentifier = "ScreenShotCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamePlatformsCollection.register(UINib.init(nibName: platformCellIdentifier, bundle: nil), forCellWithReuseIdentifier: platformCellIdentifier)
        gamePlatformsCollection.delegate = self
        gamePlatformsCollection.dataSource = self
        
        gameGenreCollection.register(UINib(nibName: genreCellIdentifier, bundle: nil), forCellWithReuseIdentifier: genreCellIdentifier)
        gameGenreCollection.delegate = self
        gameGenreCollection.dataSource = self
        
        screenShotsCollection.register(UINib(nibName: screenShotCellIdentifier, bundle: nil), forCellWithReuseIdentifier: screenShotCellIdentifier)
        screenShotsCollection.delegate = self
        screenShotsCollection.dataSource = self
        
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
        gameDescriptionTextView.layer.cornerRadius = 5
    }
    
    
}
//MARK: - Platforms and Genre collection
extension GameDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == gamePlatformsCollection {
            return platformNameArr.count
        } else if collectionView == gameGenreCollection{
            return genreArr.count
        } else {
            return screenshotArr.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == gamePlatformsCollection {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: platformCellIdentifier, for: indexPath) as? PlatformCell else {return UICollectionViewCell()}
            cell.Platform.text = platformNameArr[indexPath.row]
            return cell
        } else if collectionView == gameGenreCollection {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: genreCellIdentifier, for: indexPath) as? GenreCell else {return UICollectionViewCell()}
            cell.genre.text = genreArr[indexPath.row]
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: screenShotCellIdentifier, for: indexPath) as? ScreenShotCell else {return UICollectionViewCell()}
            cell.attachScreenshots(screenshot: screenshotArr[indexPath.row])
            cell.pageControl.numberOfPages = screenshotArr.count
            cell.pageControl.currentPage = indexPath.row
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenShotsCollection.bounds.width, height: screenShotsCollection.bounds.height)
    }
    
}

