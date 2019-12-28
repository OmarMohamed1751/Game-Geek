//
//  Genre.swift
//  Game Geek
//
//  Created by Omar Mohamed on 12/20/19.
//  Copyright © 2019 Omar Mohamed. All rights reserved.
//

import Foundation

// MARK: - Genre
struct Genre: Codable {
    let results: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let id: Int?
    let name: String?
    let games: [GenreGames]?
    var isSelected: Bool?
}

// MARK: - Game
struct GenreGames: Codable {
    let id: Int?
    let slug, name: String?
    let added: Int?
}
