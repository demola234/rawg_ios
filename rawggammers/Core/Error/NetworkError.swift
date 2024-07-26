//
//  NetworkError.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//


import Foundation

enum NetworkError: LocalizedError {
    case badURL
    case requestFailed(Error)
    case invalidResponse
    case invalidData
    case statusCode(Int)
    case fileNotFound

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "The URL is invalid."
        case .requestFailed(let error):
            return "The request failed with error: \(error.localizedDescription)"
        case .invalidResponse:
            return "The response from the server was invalid."
        case .invalidData:
            return "The data received from the server was invalid."
        case .statusCode(let code):
            return "The server responded with a status code: \(code)"
        case .fileNotFound:
            return "The file could not be found."
        }
    }
}
