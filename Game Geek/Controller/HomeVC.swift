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
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    fileprivate let gameCellIdentifier = "GameCell"
    fileprivate let genreCellIdentifier = "GenreCell"
    var genresArr = [Result]()
    var allGamesArr = [GameResult]()
    var nextPage = 1
    var previousPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        gameListTable.register(UINib(nibName: gameCellIdentifier, bundle: nil), forCellReuseIdentifier: gameCellIdentifier)
        gameListTable.delegate = self
        gameListTable.dataSource = self
        
        genreCollection.register(UINib.init(nibName: genreCellIdentifier, bundle: nil), forCellWithReuseIdentifier: genreCellIdentifier)
        genreCollection.delegate = self
        genreCollection.dataSource = self
        
        uiSetup()
        setAllGenres()
        setAllGames()
        
    }
    
    func uiSetup() {
        self.previousBtn.isHidden = true
    }
    
    func setAllGenres() {
        API.getAllGenres(controller: self) { (error, genre) in
            if let error = error {
                print(error)
                self.showAlert(title: "Opps!", message: error.localizedDescription)
            } else {
                if let genre = genre {
                    if let genreArray = genre.results {
                        let all = Result(id: 0, name: "All", games: [], isSelected: true)
                        self.genresArr = genreArray
                        self.genresArr.insert(all, at: 0)
                        self.genreCollection.reloadData()
                    }
                }
            }
        }
    }
    
    func setAllGames() {
        self.nextPage = 1
        API.getAllGames(controller: self, pageCount: nextPage) { (error, game) in
            if let error = error {
                print(error)
                self.showAlert(title: "Opps!", message: error.localizedDescription)
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
    
    @IBAction func previousBtn(_ sender: UIButton) {
        API.getPreviousGames(controller: self, pageCount: previousPage) { (error, game) in
            if let error = error {
                print(error)
                self.showAlert(title: "Opps!", message: error.localizedDescription)
            } else {
                if let game = game {
                    if let allGames = game.results {
                        self.allGamesArr.removeAll()
                        self.allGamesArr = allGames
                        self.nextPage -= 1
                        self.previousPage -= 1
                        self.gameListTable.reloadData()
                    }
                }
                if self.previousPage == 0 {
                    self.previousBtn.isHidden = true
                }
            }
        }
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        self.nextPage += 1
        API.getNextGames(controller: self, pageCount: nextPage) { (error, game) in
            if let error = error {
                print(error)
                self.showAlert(title: "Opps!", message: error.localizedDescription)
            } else {
                if let game = game {
                    if let allGames = game.results {
                        self.allGamesArr.removeAll()
                        self.allGamesArr = allGames
                        self.previousPage += 1
                        self.gameListTable.reloadData()
                        self.previousBtn.isHidden = false
                    }
                }
            }
        }
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
        
        if self.genresArr[indexPath.row].isSelected ?? false {
            cell.containerView.backgroundColor = #colorLiteral(red: 0, green: 0.7281640172, blue: 0.7614847422, alpha: 1)
            cell.genre.textColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        } else {
            cell.containerView.backgroundColor = #colorLiteral(red: 0.2874289155, green: 0.3110945523, blue: 0.3452425599, alpha: 1)
            cell.genre.textColor = #colorLiteral(red: 0, green: 0.7281640172, blue: 0.7614847422, alpha: 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.setAllGames()
        } else {
            print(indexPath.row)
        }
        
        for i in 0..<genresArr.count {
            genresArr[i].isSelected = false
        }
        genresArr[indexPath.row].isSelected = true
        collectionView.reloadData()
        
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
}
