//
//  ApiResponse.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//


import Foundation

struct ApiResponse<T: Decodable>: Decodable {
    let meta: Meta
    let data: T
}

struct Meta: Codable {
    let status: String
    let statusCode: Int
    let timestamp: String
    let message: String
}
