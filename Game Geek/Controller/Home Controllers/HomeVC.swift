//
//  ViewController.swift
//  Game Geek
//
//  Created by Omar Mohamed on 12/20/19.
//  Copyright © 2019 Omar Mohamed. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var genreCollection: UICollectionView!
    @IBOutlet weak var gameListTable: UITableView!
    @IBOutlet weak var pageStackView: UIStackView!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageCountView: UIView!
    @IBOutlet weak var pageCountLabel: UILabel!
    
    // MARK: - Vars and Lets
    fileprivate let gameCellIdentifier = "GameCell"
    fileprivate let genreCellIdentifier = "GenreCell"
    var genresArr = [Result]()
    var allGamesArr = [GameResult]()
    var currentPage = 1
    var previousPage = 0
    var allStoresArr = [StoreResult]()
    
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
        setAllGenres()
        setAllGames()
        self.previousBtn.isHidden = true
        self.pageCountView.layer.cornerRadius = pageCountView.bounds.height / 2
        self.infoLbl.isHidden = true
    }
    
    // MARK: - Calling all genres function
    func setAllGenres() {
        showIndicator(withTitle: "Loading..", and: "")
        API.getAllGenres(controller: self) { (error, genre) in
            if let error = error {
                print(error)
                self.hideIndicator()
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
            self.hideIndicator()
        }
    }
    
    // MARK: - Calling all games function
    func setAllGames() {
        showIndicator(withTitle: "Loading..", and: "")
        self.pageCountLabel.text = "\(currentPage)"
        API.getAllGames(controller: self, pageCount: currentPage) { (error, game) in
            if let error = error {
                print(error)
                self.hideIndicator()
                self.pageStackView.isHidden = true
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
            
            if self.allGamesArr.isEmpty {
                self.infoLbl.isHidden = false
            } else {
                self.infoLbl.isHidden = true
            }
            
            self.gameListTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
            
            self.hideIndicator()
        }
    }
    
    // MARK: - Back and Next buttons
    @IBAction func previousBtn(_ sender: UIButton) {
        showIndicator(withTitle: "Loading..", and: "")
        self.pageCountLabel.text = "\(currentPage - 1)"
        API.getPreviousGames(controller: self, pageCount: previousPage) { (error, game) in
            if let error = error {
                print(error)
                self.showIndicator(withTitle: "Loading..", and: "")
                self.hideIndicator()
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
                
                self.gameListTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
                self.genreCollection.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
                
                self.hideIndicator()
            }
            
            for item in 0 ..< self.genresArr.count {
                self.genresArr[item].isSelected = false
            }
            self.genresArr[0].isSelected = true
            self.genreCollection.reloadData()
            
            if self.previousPage == 0 {
                self.previousBtn.isHidden = true
            }
            
            if self.allGamesArr.isEmpty {
                self.infoLbl.isHidden = false
            } else {
                self.infoLbl.isHidden = true
            }
            
            
        }
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        showIndicator(withTitle: "Loading..", and: "")
        self.currentPage += 1
        self.pageCountLabel.text = "\(currentPage)"
        API.getNextGames(controller: self, pageCount: currentPage) { (error, game) in
            if let error = error {
                print(error)
                self.hideIndicator()
                self.showAlert(title: "Opps!", message: error.localizedDescription)
            } else {
                if let game = game {
                    if let allGames = game.results {
                        self.allGamesArr.removeAll()
                        self.allGamesArr = allGames
                        self.gameListTable.reloadData()
                        self.previousPage += 1
                        self.previousBtn.isHidden = false
                    }
                }
                
                self.gameListTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
                self.genreCollection.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
                
                self.hideIndicator()
            }
            
            for item in 0 ..< self.genresArr.count {
                self.genresArr[item].isSelected = false
            }
            self.genresArr[0].isSelected = true
            self.genreCollection.reloadData()
            
            if self.allGamesArr.isEmpty {
                self.infoLbl.isHidden = false
            } else {
                self.infoLbl.isHidden = true
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
        showIndicator(withTitle: "Loading..", and: "")
        if indexPath.row == 0 {
            self.setAllGames()
            self.hideIndicator()
        } else {
            API.getAllGames(controller: self, pageCount: currentPage) { (error, games) in
                if let error = error {
                    print(error)
                    self.hideIndicator()
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
                                self.infoLbl.isHidden = true
                                self.gameListTable.reloadData()
                            }
                            
                            if self.allGamesArr.isEmpty {
                                self.infoLbl.isHidden = false
                            } else {
                                self.gameListTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
                            }
                        }
                    }
                    self.hideIndicator()
                }
            }
        }
        
        for item in 0 ..< genresArr.count {
            genresArr[item].isSelected = false
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
        gameDetailVC.gameImageString = gameImage
        
        guard let gameName = allGamesArr[indexPath.row].name else { return }
        gameDetailVC.gameNameString = gameName
        
        guard let releaseDate = allGamesArr[indexPath.row].released else { return }
        gameDetailVC.releaseDateString = releaseDate
        
        guard let gameRate = allGamesArr[indexPath.row].rating else { return }
        gameDetailVC.gameRateString = "\(gameRate)"
        
        if let gamePlatform = allGamesArr[indexPath.row].platforms {
            for platform in gamePlatform {
                if let platformName = platform.platform?.name {
                    gameDetailVC.platformNameArr.append(platformName)
                    if platformName == "PC" {
                        gameDetailVC.requirements = platform.requirementsEn
                    }
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
        
        if let gameSlug = allGamesArr[indexPath.row].slug {
            API.getGameDetails(controller: self, gameName: gameSlug) { (error, details) in
                if let error = error {
                    print(error)
                    self.showAlert(title: "Opps!", message: error.localizedDescription)
                } else {
                    if let details = details {
                        gameDetailVC.gameDescriptionTextView.text = details.gameDescription
                        gameDetailVC.gameWebsiteLbl.text = details.website ?? "We Couldn't Find The Game Website!"
                    }
                }
            }
        }
        
        if let shortScreenshots = allGamesArr[indexPath.row].shortScreenshots {
            gameDetailVC.screenshotArr = shortScreenshots
        }
        
        if let gameVideoURL = allGamesArr[indexPath.row].clip?.clips?.full {
            gameDetailVC.gameVideoURLString = gameVideoURL
        }
        
        if let gameStoresElements = allGamesArr[indexPath.row].stores  {
            for gameStoreElement in gameStoresElements {
                if let gameStoreId = gameStoreElement.gameStore?.id {
                    API.getAllStores(controller: self) { (error, gameStore) in
                        if let error = error {
                            print(error)
                            self.showAlert(title: "Opps!", message: error.localizedDescription)
                        } else {
                            if let stores = gameStore?.results {
                                for store in stores {
                                    if gameStoreId == store.storeId {
                                        if let url = gameStoreElement.buyLink {
                                            gameDetailVC.buyingStores.append(url)
                                        }
                                        
                                        if gameDetailVC.buyingStores.isEmpty {
                                            gameDetailVC.noStoresLbl.isHidden = false
                                        } else {
                                            gameDetailVC.noStoresLbl.isHidden = true
                                        }
                                        
                                        gameDetailVC.storesArr.append(store)
                                        gameDetailVC.storesCollection.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        navigationController?.pushViewController(gameDetailVC, animated: true)
        
    }
}
