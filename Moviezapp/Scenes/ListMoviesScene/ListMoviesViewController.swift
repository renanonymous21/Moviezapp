//
//  ListMoviesViewController.swift
//  Moviezapp
//
//  Created by Rendy K. R on 10/03/21.
//

import UIKit

class ListMoviesViewController: UIViewController {
    
    @IBOutlet weak private var listMoviesTable: UITableView!
    @IBOutlet weak private var categoriesButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    private var listMoviesViewModel = ListMoviesViewModel()
    private var tableDataSource: ListMoviesTableView<ListMoviesTableViewCell, MovieModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = listMoviesTable.indexPathForSelectedRow {
            listMoviesTable.deselectRow(at: indexPath, animated: animated)
        }
        
    }
    
    @IBAction func CategoriesTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let titleAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: "Select Category", attributes: titleAttributes)
        alertController.setValue(titleString, forKey: "attributedTitle")
        alertController.popoverPresentationController?.sourceView = self.view
        
        let popular = UIAlertAction(title: "Popular", style: .default) { action -> Void in
            self.listMoviesViewModel.fetchMovies(.popular, isFirstLoad: true)
            self.categoryLabel.text = "Popular Movies"
        }
        
        let upcoming = UIAlertAction(title: "Upcoming", style: .default) { action -> Void in
            self.listMoviesViewModel.fetchMovies(.upcoming, isFirstLoad: true)
            self.categoryLabel.text = "Upcoming Movies"
        }
        
        let topRated = UIAlertAction(title: "Top Rated", style: .default) { action -> Void in
            self.listMoviesViewModel.fetchMovies(.topRated, isFirstLoad: true)
            self.categoryLabel.text = "Top Rated Movies"
        }
        
        let nowPlaying = UIAlertAction(title: "Now Playing", style: .default) { action -> Void in
            self.listMoviesViewModel.fetchMovies(.nowPlaying, isFirstLoad: true)
            self.categoryLabel.text = "Now Playing Movies"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(popular)
        alertController.addAction(upcoming)
        alertController.addAction(topRated)
        alertController.addAction(nowPlaying)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        let destination = UIStoryboard(name: "FavoriteMovies", bundle: nil)
        guard let favoriteMoviesViewController = destination.instantiateViewController(withIdentifier: "FavoriteMoviesStoryboard") as? FavoriteMoviesTableViewController else { return }
        let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        navigationController?.pushViewController(favoriteMoviesViewController, animated: true)
    }
    
    private func updateUI() {
        self.title = {
            let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
            
            return bundleDisplayName ?? bundleName
        }()
        categoryLabel.text = "Popular Movies"
        
        categoriesButton.layer.cornerRadius = 20
        categoriesButton.clipsToBounds = true
        updateData()
        listMoviesTable.dataSource = tableDataSource
        listMoviesTable.delegate = tableDataSource
        
        listMoviesViewModel.movies.bind { _ in
            DispatchQueue.main.async {
                self.listMoviesTable.reloadData()
            }
        }
        listMoviesViewModel.isError.bind { isError in
            if isError == true {
                GlobalAlert.info(title: "Error", message: self.listMoviesViewModel.errorMessage.value!!)
            }
        }
    }
    
    private func updateData() {
        let data = listMoviesViewModel.movies
        tableDataSource = ListMoviesTableView(cellIdentifier: "listMoviesCell", data: data, setupCell: {
            (cell, viewModel) in
            
            cell.configure(viewModel)
        }, viewModel: listMoviesViewModel)
    }
}

