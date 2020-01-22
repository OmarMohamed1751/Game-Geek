//
//  SearchVC.swift
//  Game Geek
//
//  Created by Omar Mohamed on 1/17/20.
//  Copyright © 2020 Omar Mohamed. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var gameTable: UITableView!
    @IBOutlet weak var infoLbl: UILabel!
    
    fileprivate let gameCellIdentifier = "GameCell"
    var allGamesArr = [GameResult]()
    var gamesFilteredArr = [GameResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        gameTable.register(UINib(nibName: gameCellIdentifier, bundle: nil), forCellReuseIdentifier: gameCellIdentifier)
        gameTable.delegate = self
        gameTable.dataSource = self
        
        searchText.delegate = self
    }
    
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gamesFilteredArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: gameCellIdentifier, for: indexPath) as? GameCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.attachGames(game: gamesFilteredArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let gameDetailVC = storyboard?.instantiateViewController(withIdentifier: "GameDetailVC") as? GameDetailVC else { return }

        guard let gameImage = gamesFilteredArr[indexPath.row].backgroundImage else { return }
        guard let gameName = gamesFilteredArr[indexPath.row].name else { return }
        
        gameDetailVC.gameImageString = gameImage
        gameDetailVC.gameNameString = gameName
        
        if let gameName = allGamesArr[indexPath.row].name {
            gameDetailVC.gameName.text = gameName
        }
        
        if let gamePlatform = gamesFilteredArr[indexPath.row].platforms {
            for platform in gamePlatform {
                if let platformName = platform.platform?.name {
                    gameDetailVC.platformNameArr.append(platformName)
                }
            }
        }
        
        if let gameGenres = gamesFilteredArr[indexPath.row].genres {
            for genre in gameGenres {
                if let genreName = genre.name{
                    gameDetailVC.genreArr.append(genreName)
                }
            }
        }
        
        if let gameSlug = gamesFilteredArr[indexPath.row].slug {
            API.getGameDetails(controller: self, gameName: gameSlug) { (error, details) in
                if let error = error {
                    print(error)
                    self.showAlert(title: "Opps!", message: error.localizedDescription)
                } else {
                    if let details = details {
                        gameDetailVC.gameDescriptionTextView.text = details.gameDescription
                    }
                }
            }
        }
        
        if let shortScreenshots = gamesFilteredArr[indexPath.row].shortScreenshots {
            gameDetailVC.screenshotArr = shortScreenshots
        }
        
        navigationController?.pushViewController(gameDetailVC, animated: true)
        
    }
    
}

extension SearchVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.infoLbl.isHidden = true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            self.infoLbl.isHidden = false
        } else {
            self.infoLbl.isHidden = true
        }
    }
    
}
