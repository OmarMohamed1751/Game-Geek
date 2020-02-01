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
    let genres: [GameGenre]?
    let shortScreenshots: [ShortScreenshot]?
    let clip: GameClip?
    let stores: [StoreElement]?
    
    enum CodingKeys: String, CodingKey{
        case id, slug, name, released, rating, platforms, genres, clip, stores
        case backgroundImage = "background_image"
        case shortScreenshots = "short_screenshots"
    }
}

// MARK: - Platform Element
struct PlatformElement: Codable {
    let platform: Platform?
    let requirementsEn: Requirements?
    enum CodingKeys: String, CodingKey{
        case platform
        case requirementsEn = "requirements_en"
    }
    
}

// MARK: - Platform
struct Platform: Codable {
    let name: String?
}

// MARK: - Genre
struct GameGenre: Codable {
    let id: Int?
    let name, slug: String?
    let gamesCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
    }
}

// MARK: - ShortScreenshot
struct ShortScreenshot: Codable {
    let image: String?
}

// MARK: - GameClip
struct GameClip: Codable {
    let clips: GameClips?
}

// MARK: - GameClips
struct GameClips: Codable {
    let the320, the640, full: String?

    enum CodingKeys: String, CodingKey {
        case the320 = "320"
        case the640 = "640"
        case full
    }
}

// MARK: - Requirements
struct Requirements: Codable {
    let minimum: String?
    let recommended: String?
}

// MARK: - StoreElement
struct StoreElement: Codable {
    let buyLink: String?
    let gameStore: GameBuyingStore?
    
    enum CodingKeys: String, CodingKey {
        case buyLink = "url_en"
        case gameStore = "store"
    }
}

// MARK: - Store
struct GameBuyingStore: Codable {
    let id: Int?
}
