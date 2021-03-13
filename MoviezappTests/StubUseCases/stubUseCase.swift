//
//  stubUseCase.swift
//  MoviezappTests
//
//  Created by Rendy K. R on 13/03/21.
//

import Foundation

struct EmptyModel: Codable {}

enum StubErrorUseCase: HttpProtocol {
    case testEndpointNotFound
    case testWrongApiKey
    
    var key: String {
        switch self {
        case .testEndpointNotFound:
            let key = ServerEnvironments.shared.moviesApiKey
            return key
        case .testWrongApiKey:
            return "qwerty123"
        }
    }
    
    var apiVersion: String {
        return "/3"
    }
    
    var base: String {
        let baseUrl = ServerEnvironments.shared.moviesBaseUrl + apiVersion
        
        return baseUrl
    }
    
    var path: String {
        let moviePath = apiVersion + "/movie"
        switch self {
        case .testEndpointNotFound,
             .testWrongApiKey:
            return moviePath + "/qwerty123"
        }
    }
    
    var queryParameters: [URLQueryItem] {
        switch self {
        case .testEndpointNotFound,
             .testWrongApiKey:
            return [
                URLQueryItem(name: "api_key", value: key),
                URLQueryItem(name: "language", value: "en-US")
            ]
        }
    }
    
    var urlComponents: URLComponents {
        guard var components = URLComponents(string: base) else {
            fatalError("Base URL not declared")
        }
        switch self {
        case .testEndpointNotFound,
             .testWrongApiKey:
            components.queryItems = queryParameters
            components.path = path
            
            return components
        }
    }
    
    var request: URLRequest {
        guard let url = urlComponents.url else {
            fatalError("URL Components not configured!")
        }
        switch self {
        case .testEndpointNotFound,
             .testWrongApiKey:
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.get.rawValue
            
            return request
        }
    }
}
