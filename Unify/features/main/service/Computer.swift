//
//  Laptop.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//



struct Computer: Decodable {
    let brand: String
    let model: String
    let processor: String
    let ram: String
    let storage: String
    let graphics: String
    let price: Double
    let releaseYear: Int
    let operatingSystem: String
    let screenSize: String

    enum CodingKeys: String, CodingKey {
        case brand
        case model
        case processor
        case ram
        case storage
        case graphics
        case price
        case releaseYear = "release_year"
        case operatingSystem = "operating_system"
        case screenSize = "screen_size"
    }
}
