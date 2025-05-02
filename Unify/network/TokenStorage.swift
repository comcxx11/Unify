//
//  TokenStorage.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//

import Foundation
import KeychainAccess

//final class TokenStorage {
//    static let shared = TokenStorage()
//
//    func save(accessToken: String?, refreshToken: String?) {
//        guard let access = accessToken, let refresh = refreshToken else { return }
//        // Keychain 또는 UserDefaults에 저장
//        UserDefaults.standard.set(access, forKey: "access_token")
//        UserDefaults.standard.set(refresh, forKey: "refresh_token")
//    }
//
//    var accessToken: String? {
//        return UserDefaults.standard.string(forKey: "access_token")
//    }
//
//    var refreshToken: String? {
//        return UserDefaults.standard.string(forKey: "refresh_token")
//    }
//}

final class TokenStorage {
    static let shared = TokenStorage()
    private let keychain = Keychain(service: "com.yourapp.identifier")

    func save(accessToken: String?, refreshToken: String?) {
        if let access = accessToken {
            try? keychain.set(access, key: "access_token")
        }
        if let refresh = refreshToken {
            try? keychain.set(refresh, key: "refresh_token")
        }
    }

    var accessToken: String? {
        return try? keychain.get("access_token")
    }

    var refreshToken: String? {
        return try? keychain.get("refresh_token")
    }

    func clear() {
        try? keychain.remove("access_token")
        try? keychain.remove("refresh_token")
    }
}
