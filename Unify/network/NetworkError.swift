//
//  NetworkError.swift
//  Unify
//
//  Created by Seojin on 5/2/25.
//



import Foundation

enum NetworkError: LocalizedError {
    case badURL
    case requestFailed
    case encodingFailed
    case decodingFailed
    case serverError
    case unauthorized
    case apiError(String)
    case encryptionError(Error)
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "잘못된 URL입니다."
        case .requestFailed:
            return "요청에 실패했습니다."
        case .encodingFailed:
            return "데이터 인코딩에 실패했습니다."
        case .decodingFailed:
            return "데이터 디코딩에 실패했습니다."
        case .serverError:
            return "서버 오류가 발생했습니다."
        case .unauthorized:
            return "인증되지 않은 사용자입니다."
        case .apiError(let message):
            return message
        case .encryptionError(let error):
            return "\(error.localizedDescription)"
        }
    }
}
