//
//  ViewController.swift
//  Game Geek
//
//  Created by Omar Mohamed on 12/20/19.
//  Copyright © 2019 Omar Mohamed. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var genreCollection: UICollectionView!
    @IBOutlet weak var gameListTable: UITableView!
    
    fileprivate let gameCellIdentifier = "GameCell"
    fileprivate let genreCellIdentifier = "GenreCell"
    
    var genresArr = [Result]()
    var allGamesArr = [GameResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        gameListTable.register(UINib(nibName: gameCellIdentifier, bundle: nil), forCellReuseIdentifier: gameCellIdentifier)
        gameListTable.delegate = self
        gameListTable.dataSource = self
        
        genreCollection.register(UINib.init(nibName: genreCellIdentifier, bundle: nil), forCellWithReuseIdentifier: genreCellIdentifier)
        genreCollection.delegate = self
        genreCollection.dataSource = self
        
        setAllGenres()
        setAllGames()
    }
    
    func setAllGenres() {
        API.getAllGenres(controller: self) { (error, genre) in
            if let error = error {
                print(error)
            } else {
                if let genre = genre {
                    if let genreArray = genre.results {
                        let all = Result(id: 0, name: "All", games: [])
                        self.genresArr = genreArray
                        self.genresArr.insert(all, at: 0)
                        self.genreCollection.reloadData()
                    }
                }
            }
        }
    }
    
    func setAllGames() {
        API.getAllGames(controller: self) { (error, game) in
            if let error = error {
                print(error)
            } else {
                if let game = game {
                    if let allGames = game.results {
                        self.allGamesArr = allGames
                        self.gameListTable.reloadData()
                    }
                }
            }
        }
    }


}

// MARK: - Games Table
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allGamesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: gameCellIdentifier, for: indexPath) as? GameCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.attachGames(game: allGamesArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

// MARK: - Genres Collection
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        genresArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: genreCellIdentifier, for: indexPath) as? GenreCell else {return UICollectionViewCell()}
        cell.attachTheGenres(result: genresArr[indexPath.row])
        
//        if cell.isSelected {
//            cell.containerView.backgroundColor = #colorLiteral(red: 0, green: 0.7281640172, blue: 0.7614847422, alpha: 1)
//            cell.genre.textColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
//        } else {
//            cell.containerView.backgroundColor = #colorLiteral(red: 0.2874289155, green: 0.3110945523, blue: 0.3452425599, alpha: 1)
//            cell.genre.textColor = #colorLiteral(red: 0, green: 0.7281640172, blue: 0.7614847422, alpha: 1)
//        }
        
        if cell.isSelected {
            self.genresArr[indexPath.row].isSelected = true
            print("hohohohohohohohoho")
        }else {
            self.genresArr[indexPath.row].isSelected = false
        }
        
        
//        if self.genresArr[indexPath.row].isSelected {
//            cell.containerView.backgroundColor = #colorLiteral(red: 0, green: 0.7281640172, blue: 0.7614847422, alpha: 1)
//            cell.genre.textColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
//        } else {
//            cell.containerView.backgroundColor = #colorLiteral(red: 0.2874289155, green: 0.3110945523, blue: 0.3452425599, alpha: 1)
//            cell.genre.textColor = #colorLiteral(red: 0, green: 0.7281640172, blue: 0.7614847422, alpha: 1)
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.genresArr[indexPath.row].isSelected = true
//        collectionView.reloadData()
        
//        if self.genresArr[indexPath.row].isSelected == true {
//            print("hohohohohohohohoho")
//        }
        
        if indexPath.row == 0 {
            self.setAllGames()
        } else {
            print(indexPath.row)
        }
    }
}
