//
//  ViewController.swift
//  FilmBox
//
//  Created by Alexander Shipunov on 17/12/2016.
//  Copyright © 2016 Alexander Shipunov. All rights reserved.
//

import UIKit
import CoreData

class MovieDetailsViewController: UIViewController, SavingViewControllerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var genreLable: UILabel!
    @IBOutlet weak var imdbRatingLabel: UILabel!
    @IBOutlet weak var lastSeenLable: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    
    var imdbID = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        print(imdbID)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadData() {
        let fetchRequest:NSFetchRequest<Film> = Film.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbID = %@", imdbID)
        
        do {
            let fetchedFilms = try DatabaseController.getContext().fetch(fetchRequest)
            let foundFilm = fetchedFilms[0] as Film
            
            titleLabel.text = foundFilm.title!
            yearLabel.text = foundFilm.year!
            runtimeLabel.text = foundFilm.runtime!
            genreLable.text = foundFilm.genre!
            imdbRatingLabel.text = foundFilm.imdbRating!
            
            if let actualLastSeen = foundFilm.lastSeen {
                lastSeenLable.text = (actualLastSeen as Date).string(format: "dd-MM-yyyy")
            } else {
                lastSeenLable.text = "Not set"
            }
            
            navBar.title = foundFilm.title!
            
        } catch {
            print(error)
        }

    }
    
    func saveDate(date: Date) {
        let fetchRequest:NSFetchRequest<Film> = Film.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbID = %@", imdbID)
        
        do {
            let fetchedFilms = try DatabaseController.getContext().fetch(fetchRequest)
            let foundFilm = fetchedFilms[0] as Film
            
            foundFilm.lastSeen = date as NSDate?
            
            do {
                try DatabaseController.getContext().save()
            } catch {
                print(error)
            }
            
        } catch {
            print(error)
        }
        
        loadData()
    }

    @IBAction func deleteFilm(_ sender: UIBarButtonItem) {
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
        
        _ = navigationController?.popViewController(animated: true)
        
        print("Film with \(imdbID) has been deleted")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func updateLastSeenDate(_ sender: Any) {
        let popOverDP = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dataPickerPopUp") as! PopUpViewController
        self.addChildViewController(popOverDP)
        popOverDP.view.frame = self.view.frame
        self.view.addSubview(popOverDP.view)
        popOverDP.delegate = self
        popOverDP.didMove(toParentViewController: self)
    }
}

// http://stackoverflow.com/a/35170528/5552809
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
