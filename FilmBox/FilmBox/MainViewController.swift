//
//  MainTableViewController.swift
//  FilmBox
//
//  Created by Alexander Shipunov on 17/12/2016.
//  Copyright © 2016 Alexander Shipunov. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var savedFilms = [Film]()
    var filmsToShow = [Film]()
    
    @IBOutlet weak var rating: UILabel!
    var selectedValue = String()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
    }
    
    func loadData() {
        let fetchRequest:NSFetchRequest<Film> = Film.fetchRequest()
        do {
            let searchRes = try DatabaseController.getContext().fetch(fetchRequest)
            
            for result in searchRes as [Film] {
                switch selectedValue {
                case "Recommended":
                    if let actualSeenDate = result.lastSeen {
                        if daysBetween(start: actualSeenDate as Date, end: NSDate() as Date) >= 1095 && Double(result.imdbRating!)! > 7.0 {
                            filmsToShow.append(result)
                        }
                    }
                    
                default:
                    filmsToShow.append(result)
                }
                print("\(result.title!) \(result.year!)")
            }
        } catch {
            print(error)
        }
        
        setRating()
        tableView.reloadData()
    }
    
    func setRating() {
        if filmsToShow.count == 0 {
            rating.text = "NA"
        } else {
            var ratingSum = 0.0
            for film in filmsToShow {
                ratingSum = ratingSum + Double(film.imdbRating!)!
            }
            rating.text = String(format:"%.1f", ratingSum/(Double(filmsToShow.count)))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filmsToShow.removeAll()
        loadData()
    }
    
    @IBAction func segmentedBarChanged(_ sender: UISegmentedControl) {
        selectedValue = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        filmsToShow.removeAll()
        loadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmsToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteFilmCell", for: indexPath)
        
        let titleLable = cell.viewWithTag(1) as! UILabel
        let seenLable = cell.viewWithTag(2) as! UILabel
        
        let film = filmsToShow[indexPath.row]
        titleLable.text = film.title
        
        if film.lastSeen != nil {
            seenLable.text = "👁"
        } else {
            seenLable.text = ""
        }
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetails" {
            let indexPath = self.tableView.indexPathForSelectedRow?.row
            
            let viewController = segue.destination as! MovieDetailsViewController
            
            viewController.imdbID = filmsToShow[indexPath!].imdbID!
        }
    }
    
    public func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
}
