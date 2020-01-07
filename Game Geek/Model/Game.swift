//
//  Game.swift
//  Game Geek
//
//  Created by Omar Mohamed on 12/20/19.
//  Copyright © 2019 Omar Mohamed. All rights reserved.
//

import Foundation

struct Game: Codable {
    let next: String?
    let previous: String?
    let results: [GameResult]?
}

// Mark: - Results
struct GameResult: Codable {
    let id: Int?
    let slug, name, released: String?
    let backgroundImage: String?
    let rating: Double?
    let platforms: [PlatformElement]?
    
    enum CodingKeys: String, CodingKey{
        case id, slug, name, released, rating, platforms
        case backgroundImage = "background_image"
    }
}

// MARK: - Platform Element
struct PlatformElement: Codable {
    let platform: Platform?
}

// MARK: - Platform
struct Platform: Codable {
    let name: String?
}
