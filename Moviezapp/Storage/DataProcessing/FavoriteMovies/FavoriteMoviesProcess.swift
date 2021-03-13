//
//  FavoriteMoviesProcess.swift
//  Moviezapp
//
//  Created by Rendy K. R on 11/03/21.
//

import UIKit
import CoreData

protocol FavoriteMoviesStorageProcess {
    static func insert(_ model: DetailMovieModel)
    static func read() throws -> [FavoriteMoviesModel]
    static func delete(_ id: Int)
}

final class FavoriteMoviesProcess: FavoriteMoviesStorageProcess {
    
    // MARK:- Insert function

    static func insert(_ model: DetailMovieModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return
        }
        let ctx = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreDataEntities.favoriteMovies.value, in: ctx)
        
        let insert = NSManagedObject(entity: entity!, insertInto: ctx)
        insert.setValue(model.id, forKey: "id")
        insert.setValue(model.title, forKey: "title")
        insert.setValue(model.overview, forKey: "overview")
        insert.setValue(model.posterPath, forKey: "posterPath")
        insert.setValue(model.releaseDate, forKey: "releaseDate")
        insert.setValue(model.status, forKey: "status")
        insert.setValue(model.rating, forKey: "rating")
        
        do {
            try ctx.save()
        } catch {
            print(error)
        }
    }
    
    // MARK:- Read function

    static func read() throws -> [FavoriteMoviesModel] {
        var model = [FavoriteMoviesModel]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let ctx = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.favoriteMovies.value)
        
        do {
            let response = try ctx.fetch(request) as! [NSManagedObject]
            let setResponse = Set(response)
            setResponse.forEach { data in
                model.append(
                    FavoriteMoviesModel(
                        id: data.value(forKey: "id") as! Int,
                        title: data.value(forKey: "title") as! String,
                        releaseDate: data.value(forKey: "releaseDate") as! String,
                        posterPath: data.value(forKey: "posterPath") as! String,
                        status: data.value(forKey: "status") as! String,
                        overview: data.value(forKey: "overview") as! String,
                        rating: data.value(forKey: "rating") as! Double
                    )
                )
            }
        } catch {
            print(error)
        }
        
        return model
    }
    
    // MARK:- Delete single data function

    static func delete(_ id: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return
        }
        let ctx = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.favoriteMovies.value)
        request.predicate = NSPredicate(format: "id = %d", id)
        
        do {
            let data = try ctx.fetch(request)
            if data.count > 0 {
                let objectToDelete = data[0] as! NSManagedObject
                ctx.delete(objectToDelete)
                try ctx.save()
            }
        } catch {
            print(error)
        }
    }
}
