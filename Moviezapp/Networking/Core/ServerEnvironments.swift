//
//  ServerEnvironments.swift
//  Moviezapp
//
//  Created by Rendy K. R on 10/03/21.
//

import Foundation

struct ServerEnvironments {
    static var shared = ServerEnvironments()
    
    lazy var moviesApiKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "MoviesApiKey") as? String else {
            fatalError("MOVIES API KEY OBJECT NOT FOUND!")
        }
        return key
    }()
    
    lazy var moviesBaseUrl: String = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "MoviesBaseUrl") as? String else {
            fatalError("MOVIES BASE URL OBJECT NOT FOUND!")
        }
        return url
    }()
    
    lazy var imageBaseUrl: String = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "ImageBaseUrl") as? String else {
            fatalError("IMAGE BASE URL OBJECT NOT FOUND!")
        }
        return url
    }()
}
