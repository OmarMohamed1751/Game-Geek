//
//  GameDetailsVC.swift
//  Game Geek
//
//  Created by Omar Mohamed on 1/8/20.
//  Copyright © 2020 Omar Mohamed. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class GameDetailVC: UIViewController {
    
    //MARK - Outlets
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameNameView: UIView!
    @IBOutlet weak var gamePlatformsCollection: UICollectionView!
    @IBOutlet weak var gameGenreCollection: UICollectionView!
    @IBOutlet weak var gameDescriptionTextView: UITextView!
    @IBOutlet weak var screenShotsCollection: UICollectionView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var gameWebsiteLbl: UILabel!
    @IBOutlet weak var releaseAndRateView: UIView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var gameRate: UILabel!
    @IBOutlet weak var gameRequirementsTextview: UITextView!
    
    //MARK: - Vars and Lets
    var gameImageString = ""
    var gameNameString = ""
    var releaseDateString = ""
    var gameRateString = ""
    var gameVideoURLString = ""
    var requirements: Requirements?
    var platformNameArr = [String]()
    var genreArr = [String]()
    var screenshotArr = [ShortScreenshot]()
    
    let removeWordsList = ["<strong>", "</strong>", "<br>", "<ul class=><li>OS:", "<ul class=\"\">OS:", "</li>", "<li>", "</ul>", "bb_ul", "<ul class=", "<p>", ">", "<", "</p", "<p", "\"", "h2 class=bb_tag", "h2", "/h2", "//p"]
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
        
        basicUISetup()
    }
    
    func basicUISetup() {
        showIndicator(withTitle: "Loading..", and: "")
        gameName.adjustsFontSizeToFitWidth = true
        gameImage.layer.cornerRadius = 10
        gameNameView.layer.cornerRadius = 10
        gameNameView.layer.borderWidth = 1
        gameNameView.layer.borderColor = #colorLiteral(red: 0, green: 0.7281640172, blue: 0.7614847422, alpha: 1)
        gameImage.kf.setImage(with: URL(string: gameImageString), placeholder: UIImage(systemName: "gamecontroller.fill"))
        releaseAndRateView.layer.cornerRadius = 10
        releaseAndRateView.layer.borderColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        releaseAndRateView.layer.borderWidth = 0.5
        gameName.text = gameNameString
        releaseDate.text = releaseDateString
        gameRate.text = gameRateString
        gameDescriptionTextView.layer.cornerRadius = 5
        videoView.layer.cornerRadius = 5
        gameRequirementsTextview.layer.cornerRadius = 5
        settingGameRequirements()
        hideIndicator()
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        self.present(vc, animated: true) { vc.player?.play() }
    }
    
    func settingGameRequirements() {
        var minimumRequirements = requirements?.minimum
        var recommendedRequirements = requirements?.recommended
        
        for word in removeWordsList {
            let filteredMinimumRequirements = minimumRequirements?.replacingOccurrences(of: word, with: " ")
            minimumRequirements = filteredMinimumRequirements
            
            let filteredRecommendedRequirements = recommendedRequirements?.replacingOccurrences(of: word, with: " ")
            recommendedRequirements = filteredRecommendedRequirements
        }
        
        gameRequirementsTextview.text = "Minimum Requirements: \n\(minimumRequirements ?? "Sorry, we couldn't find the minimum requirements of this game!") \n\n Recommended Requirements: \n\(recommendedRequirements ?? "Sorry, we couldn't find the recommended requirements of this game!")"
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
        guard let url = URL(string: gameVideoURLString) else {
            return showAlert(title: "Opps!", message: "Sorry, we couldn't find a video of this game!")
        }
        playVideo(url: url)
    }
    
    @IBAction func weblinkIsTapped(_ sender: UIButton) {
        guard let url = URL(string: gameWebsiteLbl.text ?? "We Couldn't Find The Game Website!") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
        if collectionView == gamePlatformsCollection {
            return CGSize(width: gamePlatformsCollection.bounds.width, height: gamePlatformsCollection.bounds.height)
        } else if collectionView == gameGenreCollection {
            return CGSize(width: gameGenreCollection.bounds.width, height: gameGenreCollection.bounds.height)
        } else {
            return CGSize(width: screenShotsCollection.bounds.width, height: screenShotsCollection.bounds.height)
        }
    }
    
}

