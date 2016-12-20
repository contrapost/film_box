//
//  FilmSearchTableViewController.swift
//  FilmBox
//
//  Created by Alexander Shipunov on 19/12/2016.
//  Copyright © 2016 Alexander Shipunov. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class foundFilm {
    let title : String
    let year : String
    let imdbID : String
    var saved = false
    
    init(title: String, year: String, imdbID: String) {
        self.title = title
        self.year = year
        self.imdbID = imdbID
    }
}

class FilmSearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var films = [foundFilm]()
    
    var searchUrl = String()
    
    typealias JSONtype = [String : AnyObject]
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchString = searchBar.text
        let titleToSearch = searchString?.replacingOccurrences(of: " ", with: "+")
        
        searchUrl = "http://www.omdbapi.com/?s=\(titleToSearch!)&y=&plot=short&r=json"
        
        getSearchData(url: searchUrl)
        
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSearchData(url: String) {
        Alamofire.request(url).responseJSON(completionHandler: { response in
            
            self.parseData(JSONData: response.data!)
            
        })
    }
    
    func parseData(JSONData : Data) {
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONtype
            if let items = readableJSON["Search"] {
                for i in 0..<items.count {
                    let film = items[i] as! JSONtype
                    
             /*       print(film["Title"]!)
                    print(film["Year"]!)
                    print(film["imdbID"]!) */
                    
                    films.append(foundFilm.init(title: film["Title"] as! String!, year: film["Year"] as! String!, imdbID: film["imdbID"] as! String!))
                    
                    self.tableView.reloadData()
                }
            }
        } catch {
            print(error)
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return films.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "filmSearchCell")
        
        let titleLable = cell?.viewWithTag(1) as! UILabel
        let yearLable = cell?.viewWithTag(2) as! UILabel
        
        titleLable.text = films[indexPath.row].title
        yearLable.text = films[indexPath.row].year
        
        let fetchRequest:NSFetchRequest<Film> = Film.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbID = %@", films[indexPath.row].imdbID)
        
        do {
            let fetchedFilms = try DatabaseController.getContext().fetch(fetchRequest)
            if fetchedFilms.count != 0 {
                films[indexPath.row].saved = true
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
        } catch {
            print(error)
        }

        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        let foundFilm = films[indexPath.row]
        
        foundFilm.saved = !foundFilm.saved
        
        if foundFilm.saved {
            saveFilmToDB(imdbID: foundFilm.imdbID)
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            deleteFilmFromDB(imdbID: foundFilm.imdbID)
            cell?.accessoryType = UITableViewCellAccessoryType.none
        }
    }
    
    func saveFilmToDB(imdbID: String) {
        let searchFilmUrl = "http://www.omdbapi.com/?i=\(imdbID)&plot=short&r=json"
        
        Alamofire.request(searchFilmUrl).responseJSON(completionHandler: { response in
            
            do {
                let readableJSON = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! JSONtype
                // print(readableJSON)
                
                let fetchRequest:NSFetchRequest<Film> = Film.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "imdbID = %@", readableJSON["imdbID"] as! String)
                do {
                    let searchRes = try DatabaseController.getContext().fetch(fetchRequest)
                    if searchRes.count == 0 {
                        
                        let filmToSave: Film = NSEntityDescription.insertNewObject(forEntityName: "Film", into: DatabaseController.getContext()) as! Film
                        
                        filmToSave.title = readableJSON["Title"] as! String?
                        filmToSave.year = readableJSON["Year"] as! String?
                        filmToSave.runtime = readableJSON["Runtime"] as! String?
                        filmToSave.genre = readableJSON["Genre"] as! String?
                        filmToSave.imdbID = readableJSON["imdbID"] as! String?
                        filmToSave.imdbRating = readableJSON["imdbRating"] as! String?
                        filmToSave.lastSeen = nil
                        
                        DatabaseController.saveContext()
                        
                    }
                    
                } catch {
                    print(error)
                }
                
                let fetchRequest2:NSFetchRequest<Film> = Film.fetchRequest()
                do {
                    let searchRes = try DatabaseController.getContext().fetch(fetchRequest2)
                    
                    print("Number of results\(searchRes.count)")
                    
                    for result in searchRes as [Film] {
                        print("\(result.title!) \(result.year!)")
                    }
                } catch {
                    print(error)
                }
                
            } catch {
                print(error)
            }
            
        })
    }
    
    func deleteFilmFromDB(imdbID: String) {
        let fetchRequest:NSFetchRequest<Film> = Film.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbID = %@", imdbID)
        
        do {
            let fetchedFilms = try DatabaseController.getContext().fetch(fetchRequest)
            DatabaseController.getContext().delete(fetchedFilms[0])
            do {
                try DatabaseController.getContext().save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
        print("Film with \(imdbID) has been deleted")
    }

}
