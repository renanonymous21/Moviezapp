//
//  ListMoviesViewModel.swift
//  Moviezapp
//
//  Created by Rendy K. R on 10/03/21.
//

import Foundation

enum MoviesCategory: String {
    case popular
    case upcoming
    case topRated
    case nowPlaying
}

protocol ListMoviesBusinessLogic {
    func fetchMovies(_ category: MoviesCategory, isFirstLoad: Bool)
}

final class ListMoviesViewModel: NSObject, ListMoviesBusinessLogic {
    
    var movies = Observable<[MovieModel]>()
    var errorMessage = Observable<String?>()
    var isError = Observable<Bool>()
    var activeCategory = Observable<MoviesCategory>()
    
    private var page = 1
    private var useCase: MoviesUseCases?
    
    override init() {
        super.init()
        fetchMovies(.popular, isFirstLoad: true)
    }
    
    func fetchMovies(_ category: MoviesCategory, isFirstLoad: Bool) {
        if isFirstLoad == false && page <= 500 {
            page += 1
        } else {
            page = 1
        }
        
        switch category {
        case .popular:
            useCase = MoviesUseCases.popular(page: page)
            activeCategory.value = .popular
        case .upcoming:
            useCase = MoviesUseCases.upcoming(page: page)
            activeCategory.value = .upcoming
        case .topRated:
            useCase = MoviesUseCases.topRated(page: page)
            activeCategory.value = .topRated
        case .nowPlaying:
            useCase = MoviesUseCases.nowPlaying(page: page)
            activeCategory.value = .nowPlaying
        }
        
        if let usecase = useCase {
            request(usecase: usecase)
        }
    }
    
    private func request(usecase: MoviesUseCases) {
        APIManager.request(usecase) { [weak self] (result: Result<MoviesResponseModel, RuntimeError>) in
            do {
                let response = try result.get()
                if (self?.page ?? 1) > 1 {
                    self?.movies.value? += response.results
                } else {
                    self?.movies.value = response.results
                }
            } catch {
                print("ERROR FETCH LIST: ", error)
                let requestError = error as? RuntimeError
                self?.setError(requestError?.localizedDescription ?? "unknown")
            }
        }
    }
    
    func setError(_ message: String) {
        self.errorMessage.value = message
        self.isError.value = true
    }
}
