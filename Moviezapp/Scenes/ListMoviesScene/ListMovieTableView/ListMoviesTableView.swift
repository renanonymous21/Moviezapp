//
//  ListMoviesTableView.swift
//  Moviezapp
//
//  Created by Rendy K. R on 10/03/21.
//

import UIKit

class ListMoviesTableView<cell: UITableViewCell, T>: NSObject, UITableViewDataSource, UITableViewDelegate {
    private var cellIdentifier: String!
    private var data = Observable<[T]>()
    var setupCell: (cell, T) -> () = { _, _ in }
    var viewModel: ListMoviesViewModel!
    
    init(cellIdentifier: String, data: Observable<[T]>, setupCell: @escaping (cell, T) -> (), viewModel: ListMoviesViewModel) {
        self.cellIdentifier = cellIdentifier
        self.setupCell = setupCell
        self.data = data
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.value?.count == 0 {
            let emptyLabel = UILabel()
            emptyLabel.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)
            emptyLabel.numberOfLines = 0
            emptyLabel.text = "Sorry, no movies data found"
            emptyLabel.textAlignment = .center
            tableView.backgroundView = emptyLabel
            tableView.separatorStyle = .none
            
            return 0
        }
        
        return data.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? cell else {
            preconditionFailure("CELL IS UNKNOWN!")
        }
        
        guard let data = self.data.value?[indexPath.row] else { preconditionFailure("DATA NIL") }
        self.setupCell(cell, data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destination = UIStoryboard(name: "DetailMovie", bundle: nil)
        guard let detailViewController = destination.instantiateViewController(withIdentifier: "DetailMovieStoryboard") as? DetailMovieTableViewController else { return }
        let selectedData = self.data.value?[indexPath.row] as? MovieModel
        detailViewController.movieId = selectedData?.id
        let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cellCount = data.value?.count {
            let last = cellCount - 1
            if indexPath.row == last {
                switch viewModel.activeCategory.value {
                case .popular:
                    viewModel.fetchMovies(.popular, isFirstLoad: false)
                    break
                case .upcoming:
                    viewModel.fetchMovies(.upcoming, isFirstLoad: false)
                    break
                case .topRated:
                    viewModel.fetchMovies(.topRated, isFirstLoad: false)
                    break
                case .nowPlaying:
                    viewModel.fetchMovies(.nowPlaying, isFirstLoad: false)
                    break
                case .none:
                    break
                }
            }
        }
    }
}
