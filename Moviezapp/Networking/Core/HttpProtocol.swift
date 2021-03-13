//
//  HttpProtocol.swift
//  Moviezapp
//
//  Created by Rendy K. R on 10/03/21.
//

import Foundation

protocol HttpProtocol {
    var key: String { get }
    var apiVersion: String { get }
    var base: String { get }
    var path: String { get }
    var queryParameters: [URLQueryItem] { get }
    var urlComponents: URLComponents { get }
    var request: URLRequest { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
