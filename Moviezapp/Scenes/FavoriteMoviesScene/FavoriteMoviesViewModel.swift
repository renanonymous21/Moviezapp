//
//  FavoriteMoviesViewModel.swift
//  Moviezapp
//
//  Created by Rendy K. R on 11/03/21.
//

import Foundation

protocol FavoriteMoviesBusinessLogic {
    func getFavoriteMovies()
    func deleteMovies(_ movieId: Int)
}

final class FavoriteMoviesViewModel: NSObject, FavoriteMoviesBusinessLogic {
    
    var favoriteMovies = Observable<[FavoriteMoviesModel]>()
    var errorMessage = Observable<String?>()
    var isError = Observable<Bool>()
    
    override init() {
        super.init()
        getFavoriteMovies()
    }
    
    func getFavoriteMovies() {
        do {
            let savedMovies = try FavoriteMoviesProcess.read()
            favoriteMovies.value = savedMovies
        } catch {
            setError(error.localizedDescription)
        }
    }
    
    func deleteMovies(_ movieId: Int) {
        FavoriteMoviesProcess.delete(movieId)
        getFavoriteMovies()
    }
    
    private func setError(_ message: String) {
        self.errorMessage.value = message
        self.isError.value = true
    }
}
