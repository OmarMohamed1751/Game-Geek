//
//  GameDetails.swift
//  Game Geek
//
//  Created by Omar Mohamed on 1/17/20.
//  Copyright © 2020 Omar Mohamed. All rights reserved.
//

import Foundation

// MARK: - GameDetails
struct GameDetails: Codable {
    let id: Int
    let slug, name, nameOriginal, description: String?
    let updated: String?
    let backgroundImage: String?
    let website: String?
    let screenshotsCount: Int?
    let stores: [Store]?
    let developers, genres, tags, publishers: [Developer]?
    let clip: Clip?
    let gameDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, slug, name
        case nameOriginal = "name_original"
        case description, updated
        case backgroundImage = "background_image"
        case website
        case screenshotsCount = "screenshots_count"
        case stores, developers, genres, tags, publishers, clip
        case gameDescription = "description_raw"
    }
}

// MARK: - Clip
struct Clip: Codable {
    let clip: String?
    let clips: Clips?
    let video: String?
    let preview: String?
}

// MARK: - Clips
struct Clips: Codable {
    let the320, the640, full: String?

    enum CodingKeys: String, CodingKey {
        case the320 = "320"
        case the640 = "640"
        case full
    }
}

// MARK: - Developer
struct Developer: Codable {
    let id: Int?
    let name, slug: String?
    let gamesCount: Int?
    let imageBackground: String?
    let domain: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
        case domain
    }
}

// MARK: - Requirements
struct Requirements: Codable {
    let minimum, recommended: String?
}

// MARK: - Store
struct Store: Codable {
    let id: Int?
    let url: String?
    let store: Developer?
}
