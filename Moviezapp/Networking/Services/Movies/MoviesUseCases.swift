//
//  MoviesUseCases.swift
//  Moviezapp
//
//  Created by Rendy K. R on 10/03/21.
//

import Foundation

enum MoviesUseCases: HttpProtocol {
    case popular(page: Int)
    case upcoming(page: Int)
    case topRated(page: Int)
    case nowPlaying(page: Int)
    case getMovieDetail(movieId: Int)
    case getMovieReviews(movieId: Int, page: Int)
    
    var key: String {
        let key = ServerEnvironments.shared.moviesApiKey
        return key
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
        case .popular:
            return moviePath + "/popular"
        case .upcoming:
            return moviePath + "/upcoming"
        case .topRated:
            return moviePath + "/top_rated"
        case .nowPlaying:
            return moviePath + "/now_playing"
        case .getMovieDetail(let movieId):
            return moviePath + "/\(movieId)"
        case .getMovieReviews(let movieId, _):
            return moviePath + "/\(movieId)/reviews"
        }
    }
    
    var queryParameters: [URLQueryItem] {
        switch self {
        case .popular(let page),
             .upcoming(let page),
             .topRated(let page),
             .nowPlaying(let page),
             .getMovieReviews(_, let page):
            return [
                URLQueryItem(name: "api_key", value: key),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "language", value: "en-US")
            ]
        case .getMovieDetail:
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
        case .popular,
             .upcoming,
             .topRated,
             .nowPlaying,
             .getMovieDetail,
             .getMovieReviews:
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
        case .popular,
             .upcoming,
             .topRated,
             .nowPlaying,
             .getMovieDetail,
             .getMovieReviews:
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.get.rawValue
            
            return request
        }
    }
}
