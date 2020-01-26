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
    let storeId: Int?
    let name, domain, slug, description: String?
    let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case name, description, domain, slug
        case storeId = "id"
        case imageBackground = "image_background"
    }
}
