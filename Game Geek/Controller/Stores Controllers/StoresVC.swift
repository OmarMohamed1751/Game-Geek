//
//  StoresVC.swift
//  Game Geek
//
//  Created by Omar Mohamed on 1/17/20.
//  Copyright © 2020 Omar Mohamed. All rights reserved.
//

import UIKit

class StoresVC: UIViewController {
    
    @IBOutlet weak var storesCollection: UICollectionView!
    
    fileprivate let storeCellIdentifier = "StoreCell"
    var allStoresArr = [StoreResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        storesCollection.register(UINib.init(nibName: storeCellIdentifier, bundle: nil), forCellWithReuseIdentifier: storeCellIdentifier)
        storesCollection.delegate = self
        storesCollection.dataSource = self
        
        setupUI()
    }
    
    func setupUI() {
        showIndicator(withTitle: "Loading..", and: "")
        getAllStores()
        hideIndicator()
    }
    
    func getAllStores() {
        API.getAllStores(controller: self) { (error, gameStore) in
            if let error = error {
                print(error)
                self.showAlert(title: "Opps!", message: error.localizedDescription)
            } else {
                if let stores = gameStore?.results {
                    self.allStoresArr = stores
                    self.storesCollection.reloadData()
                }
            }
        }
    }
    
    
}

extension StoresVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allStoresArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: storeCellIdentifier, for: indexPath) as? StoreCell else {return UICollectionViewCell()}
        cell.attachStores(store: allStoresArr[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.bounds.width/2 - 10 , height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let storeDetailVC = storyboard?.instantiateViewController(withIdentifier: "StoreDetailsVC") as? StoreDetailsVC else { return }
        
        guard let storeName = allStoresArr[indexPath.row].name else { return }
        storeDetailVC.storeNameString = storeName
        
        guard let storeImageURl = allStoresArr[indexPath.row].imageBackground else { return }
        storeDetailVC.storeImageURLString = storeImageURl
        
        guard let storeDescription = allStoresArr[indexPath.row].description else { return }
        storeDetailVC.storeDescriptionString = storeDescription
        
        if let storeURL = allStoresArr[indexPath.row].domain {
            storeDetailVC.storeURLString = storeURL
        }
        
        navigationController?.pushViewController(storeDetailVC, animated: true)
    }
    
}
