//
//  ViewController.swift
//  Game Geek
//
//  Created by Omar Mohamed on 12/20/19.
//  Copyright © 2019 Omar Mohamed. All rights reserved.
//

import UIKit
import JGProgressHUD

class HomeVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var genreCollection: UICollectionView!
    @IBOutlet weak var gameListTable: UITableView!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageCountView: UIView!
    @IBOutlet weak var pageCountLabel: UILabel!
    
    // MARK: - Vars and Lets
    fileprivate let gameCellIdentifier = "GameCell"
    fileprivate let genreCellIdentifier = "GenreCell"
    let hud = JGProgressHUD(style: .dark)
    var genresArr = [Result]()
    var allGamesArr = [GameResult]()
    var currentPage = 1
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
        
        basicUISetup()
        
    }
    
    // MARK: - UI Setup
    func basicUISetup() {
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        setAllGenres()
        setAllGames()
        self.previousBtn.isHidden = true
        self.pageCountView.layer.cornerRadius = pageCountView.bounds.height / 2
        hud.dismiss(afterDelay: 0.5)
    }
    
    // MARK: - Calling all genres function
    func setAllGenres() {
        hud.show(in: self.view)
        API.getAllGenres(controller: self) { (error, genre) in
            if let error = error {
                print(error)
                self.hud.dismiss(afterDelay: 0.5)
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
        hud.dismiss(afterDelay: 0.5)
    }
    
    // MARK: - Calling all games function
    func setAllGames() {
        hud.show(in: self.view)
        self.pageCountLabel.text = "\(currentPage)"
        API.getAllGames(controller: self, pageCount: currentPage) { (error, game) in
            if let error = error {
                print(error)
                self.hud.dismiss(afterDelay: 0.5)
                self.showAlert(title: "Opps!", message: error.localizedDescription)
            } else {
                if let game = game {
                    if let allGames = game.results {
                        self.allGamesArr = allGames
                        self.gameListTable.reloadData()
                    }
                }
            }
            if self.previousPage == 0 {
                self.previousBtn.isHidden = true
            }
        }
        hud.dismiss(afterDelay: 0.5)
    }
    
    // MARK: - Back and Next buttons
    @IBAction func previousBtn(_ sender: UIButton) {
        hud.show(in: self.view)
        self.pageCountLabel.text = "\(currentPage - 1)"
        API.getPreviousGames(controller: self, pageCount: previousPage) { (error, game) in
            if let error = error {
                print(error)
                self.hud.dismiss(afterDelay: 0.5)
                self.showAlert(title: "Opps!", message: error.localizedDescription)
            } else {
                if let game = game {
                    if let allGames = game.results {
                        self.allGamesArr.removeAll()
                        self.allGamesArr = allGames
                        self.currentPage -= 1
                        self.previousPage -= 1
                        self.gameListTable.reloadData()
                    }
                }
                
                for i in 0 ..< self.genresArr.count {
                    self.genresArr[i].isSelected = false
                }
                self.genresArr[0].isSelected = true
                self.genreCollection.reloadData()
                
                if self.previousPage == 0 {
                    self.previousBtn.isHidden = true
                }
            }
        }
        hud.dismiss(afterDelay: 0.5)
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        hud.show(in: self.view)
        self.currentPage += 1
        self.pageCountLabel.text = "\(currentPage)"
        API.getNextGames(controller: self, pageCount: currentPage) { (error, game) in
            if let error = error {
                print(error)
                self.hud.dismiss(afterDelay: 0.5)
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
                
                for i in 0 ..< self.genresArr.count {
                    self.genresArr[i].isSelected = false
                }
                self.genresArr[0].isSelected = true
                self.genreCollection.reloadData()
            }
        }
        hud.dismiss(afterDelay: 0.5)
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
//            print(indexPath.row)
//            print(genresArr[indexPath.row])
            print(genresArr[indexPath.row].games ?? [])
            hud.show(in: self.view)
            API.getAllGames(controller: self, pageCount: currentPage) { (error, games) in
                if let error = error {
                    print(error)
                    self.hud.dismiss(afterDelay: 0.5)
                    self.showAlert(title: "Opps!", message: error.localizedDescription)
                } else {
                    self.allGamesArr.removeAll()
                    if let game = games {
                        if let allGames = game.results {
                            
                            for game in allGames {
                                if let genres = game.genres {
                                    for genre in genres {
                                        let genreId = genre.id
                                        if self.genresArr[indexPath.row].id == genreId {
                                            self.allGamesArr.append(game)
                                        }
                                    }
                                }
                                self.gameListTable.reloadData()
                            }
                            
                            if self.allGamesArr.isEmpty {
                                self.showAlert(title: "Nothing to show here", message: nil)
                            }
                        }
                    }
                }
            }
            hud.dismiss(afterDelay: 0.5)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let gameDetailVC = storyboard?.instantiateViewController(withIdentifier: "GameDetailVC") as? GameDetailVC else { return }

        guard let gameImage = allGamesArr[indexPath.row].backgroundImage else { return }
        guard let gameName = allGamesArr[indexPath.row].name else { return }
        
        gameDetailVC.gameImageString = gameImage
        gameDetailVC.gameNameString = gameName
        
        if let gamePlatform = allGamesArr[indexPath.row].platforms {
            for platform in gamePlatform {
                if let platformName = platform.platform?.name {
                    gameDetailVC.platformNameArr.append(platformName)
                }
            }
        }
        
        if let gameGenres = allGamesArr[indexPath.row].genres {
            for genre in gameGenres {
                if let genreName = genre.name{
                    gameDetailVC.genreArr.append(genreName)
                }
            }
        }
        
        navigationController?.pushViewController(gameDetailVC, animated: true)
        
    }
}
