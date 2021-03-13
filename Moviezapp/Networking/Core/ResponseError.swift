//
//  ResponseErrorModel.swift
//  Moviezapp
//
//  Created by Rendy K. R on 13/03/21.
//

import Foundation

struct ResponseErrorModel: Codable {
    var statusCode: Int
    var message: String
    var success: Bool
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message = "status_message"
        case success
    }
}

struct RuntimeError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
