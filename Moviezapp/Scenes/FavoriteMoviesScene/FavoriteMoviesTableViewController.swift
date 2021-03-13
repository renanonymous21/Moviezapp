//
//  FavoriteMoviesTableViewController.swift
//  Moviezapp
//
//  Created by Rendy K. R on 11/03/21.
//

import UIKit

class FavoriteMoviesTableViewController: UITableViewController {
    
    var viewModel = FavoriteMoviesViewModel()
    var detailViewModel: DetailMovieViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        
        self.clearsSelectionOnViewWillAppear = true
    }
    
    private func updateUI() {
        self.title = "Favorite Movies"
        viewModel.favoriteMovies.bind { _ in
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.favoriteMovies.value?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteMoviesCell", for: indexPath) as? MovieInformationTableViewCell
        else {
            return UITableViewCell()
        }
        if let data = viewModel.favoriteMovies.value?[indexPath.row] {
            let model = DetailMovieModel(id: data.id, title: data.title, releaseDate: data.releaseDate, posterPath: data.posterPath, status: data.status, overview: data.overview, rating: data.rating)
            cell.cofigure(model)
        }
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let movieId = viewModel.favoriteMovies.value?[indexPath.row].id {
                viewModel.deleteMovies(movieId)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = UIStoryboard(name: "DetailMovie", bundle: nil)
        guard let detailViewController = destination.instantiateViewController(withIdentifier: "DetailMovieStoryboard") as? DetailMovieTableViewController else { return }
        detailViewController.movieId = viewModel.favoriteMovies.value?[indexPath.row].id
        let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
