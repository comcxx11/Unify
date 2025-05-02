//
//  Animal.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//



struct Animal: Decodable {
    let name: String
    let scientificName: String
    let habitat: String
    let lifespan: Int
    let diet: String

    enum CodingKeys: String, CodingKey {
        case name
        case scientificName = "scientific_name"
        case habitat
        case lifespan
        case diet
    }
}
