//
//  APIManager.swift
//  Game Geek
//
//  Created by Omar Mohamed on 12/20/19.
//  Copyright © 2019 Omar Mohamed. All rights reserved.
//

import Foundation
import Alamofire

class API {
    
    // MARK: - Genre request
    static func getAllGenres(controller: UIViewController, completion: @escaping(_ error: Error?, _ genres: Genre?)-> Void) {
        let url = URLs.allGenres
        let headers = ["X-RapidAPI-Host" : "rawg-video-games-database.p.rapidapi.com",
        "X-RapidAPI-Key" : "fccd79f70bmshb3293bbf6ae36d1p1cf039jsn2cb01dedb2c6"]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .failure:
                guard let error = response.error else {return}
                controller.showAlert(title: "Opps!", message: error.localizedDescription)
                print("aaaaaaaaaaaaa" + error.localizedDescription)
                completion(error, nil)
            
            case .success:
                guard let data = response.data else { return }
                let decoder = JSONDecoder()
                do {
                    let decodedGenres = try decoder.decode(Genre.self, from: data)
                    completion(nil, decodedGenres)
                } catch {
                    controller.showAlert(title: "Opps!", message: error.localizedDescription)
                    print("bbbbbbbbbbbbb" + error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Game request
    static func getAllGames(controller: UIViewController, pageCount: Int?, completion: @escaping(_ error: Error?, _ games: Game?)-> Void) {
        let url = URLs.allGames + "\(pageCount ?? 1)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .failure:
                guard let error = response.error else {return}
                print(error.localizedDescription)
                completion(error, nil)
                
            case .success:
                guard let data = response.data else {return}
                let decoder = JSONDecoder()
                do {
                    let decodedGames = try decoder.decode(Game.self, from: data)
                    completion(nil, decodedGames)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Next page
    static func getNextGames(controller: UIViewController, pageCount: Int, completion: @escaping(_ error: Error?, _ games: Game?)-> Void) {
        let url = URLs.allGames + "\(pageCount)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .failure:
                guard let error = response.error else {return}
                print(error.localizedDescription)
                completion(error, nil)
                
            case .success:
                guard let data = response.data else {return}
                let decoder = JSONDecoder()
                do {
                    let decodedGames = try decoder.decode(Game.self, from: data)
                    completion(nil, decodedGames)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Previous page
    static func getPreviousGames(controller: UIViewController, pageCount: Int, completion: @escaping(_ error: Error?, _ games: Game?)-> Void) {
        let url = URLs.allGames + "\(pageCount)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .failure:
                guard let error = response.error else {return}
                print(error.localizedDescription)
                completion(error, nil)
                
            case .success:
                guard let data = response.data else {return}
                let decoder = JSONDecoder()
                do {
                    let decodedGames = try decoder.decode(Game.self, from: data)
                    completion(nil, decodedGames)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Game details
    static func getGameDetails(controller: UIViewController, gameName: String, completion: @escaping(_ error: Error?, _ details: GameDetails?)-> Void){
        let url = URLs.gameDetails + "\(gameName)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
                case .failure:
                    guard let error = response.error else {return}
                    print(error.localizedDescription)
                    completion(error, nil)
                    
                case .success:
                    guard let data = response.data else {return}
                    let decoder = JSONDecoder()
                    do {
                        let decodedGameDetails = try decoder.decode(GameDetails.self, from: data)
                        completion(nil, decodedGameDetails)
                    } catch {
                        print(error.localizedDescription)
                    }
            }
        }
    }
    
    //MARK: - Stores
    static func getAllStores(controller: UIViewController, completion: @escaping(_ error: Error?, _ stores: GameStore?)-> Void) {
        guard let url = Bundle.main.url(forResource: "Stores", withExtension: "json") else { return }
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
                case .failure:
                    guard let error = response.error else {return}
                    print(error.localizedDescription)
                    completion(error, nil)
                    
                case .success:
                    guard let data = response.data else {return}
                    let decoder = JSONDecoder()
                    do {
                        let decodedStores = try decoder.decode(GameStore.self, from: data)
                        completion(nil, decodedStores)
                    } catch {
                        print(error.localizedDescription)
                    }
            }
        }
    }
    
}
