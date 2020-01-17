//
//  Store.swift
//  Game Geek
//
//  Created by Omar Mohamed on 1/17/20.
//  Copyright © 2020 Omar Mohamed. All rights reserved.
//

import Foundation

// MARK: - Store
struct GameStore: Codable {
    let results: [StoreResult]?
}

// MARK: - Result
struct StoreResult: Codable {
    let id: Int?
    let name, domain, slug: String?
    let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case id, name, domain, slug
        case imageBackground = "image_background"
    }
}
