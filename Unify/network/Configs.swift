//
//  Configs.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//



import Foundation

struct Configs {
    struct App {
        static let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        static let storeUrl = "itms-apps://itunes.apple.com/app/id1033450260"   // whowho니 추후 변경
    }
    
    struct Network {
        // dev : https://api-test.vpdewallet.com/membership/api/v4
        // real : https://api.vpdewallet.com/membership/api/v4
        // static let host: String = "https://ds27.i234.me:33010/api/v1"
        static let host: String = "http://localhost:8080/api/v1"
        static let localhost: String = "http://localhost:8000"
    }
}
