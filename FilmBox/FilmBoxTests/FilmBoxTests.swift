//
//  FilmBoxTests.swift
//  FilmBoxTests
//
//  Created by Alexander Shipunov on 17/12/2016.
//  Copyright © 2016 Alexander Shipunov. All rights reserved.
//

import XCTest
import CoreData
import Alamofire
@testable import FilmBox

class FilmBoxTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        deleteAllFromDB()

    }
    
    override func tearDown() {
        super.tearDown()
        
        deleteAllFromDB()
    }
    
    func deleteAllFromDB() {
        let fetchRequest: NSFetchRequest<Film> = Film.fetchRequest()
        do {
            let searchRes = try DatabaseController.getContext().fetch(fetchRequest)
            
            for result in searchRes as [Film] {
                DatabaseController.getContext().delete(result)
            }
        } catch {
            print(error)
        }
        
        do {
            try DatabaseController.getContext().save()
        } catch {
            print(error)
        }
    }
    
    func testCreateFilmWithoutSeenDate() {
        
        let filmToSave: Film = NSEntityDescription.insertNewObject(forEntityName: "Film", into: DatabaseController.getContext()) as! Film
                
        filmToSave.title = "Title"
        filmToSave.year = "2000"
        filmToSave.runtime = "120 min"
        filmToSave.genre = "sci-fi"
        filmToSave.imdbID = "idXYZ"
        filmToSave.imdbRating = "8.0"
                
        DatabaseController.saveContext()
        
        
        let fetchRequest: NSFetchRequest<Film> = Film.fetchRequest()
        do {
            let searchRes = try DatabaseController.getContext().fetch(fetchRequest)
            
            XCTAssertEqual(searchRes.count, 1)
            XCTAssertEqual(searchRes[0].title, "Title")
            XCTAssertNil(searchRes[0].lastSeen)
        } catch {
            print(error)
        }
    }
    
    func testCreateTwoFilms() {
        saveFilmToDB(title: "Title 1", year: "2000", runtime: "120 min", genre: "Sci-fi", imdbID: "1", imdbRating: "8.0", lastSeen: NSDate.days(days: -1098)) // Should be recommended (seen > 3 years before and rating 7.0
        saveFilmToDB(title: "Title 2", year: "2000", runtime: "120 min", genre: "Sci-fi", imdbID: "2", imdbRating: "8.9", lastSeen: NSDate.days(days: -1091)) // Shouldn't been recommended seen < 3 years
        
        let fetchRequest: NSFetchRequest<Film> = Film.fetchRequest()
        do {
            let searchRes = try DatabaseController.getContext().fetch(fetchRequest)
            
            XCTAssertEqual(searchRes.count, 2)
            XCTAssertEqual(searchRes[0].title, "Title 1")
            XCTAssertEqual(searchRes[1].title, "Title 2")
        } catch {
            print(error)
        }
    }
    
    func testCreateTwoFilmsWithSameImdbID() {
        let id = "someUniqueID"
        
        saveFilmToDB(imdbID: id)
        saveFilmToDB(imdbID: id)
        
        let fetchRequest: NSFetchRequest<Film> = Film.fetchRequest()
        do {
            let searchRes = try DatabaseController.getContext().fetch(fetchRequest)
            
            XCTAssertEqual(searchRes.count, 1)
            XCTAssertEqual(searchRes[0].title, "Title")
            XCTAssertNil(searchRes[0].lastSeen)
        } catch {
            print(error)
        }
    }
    
    // Replice of delete method from FIlmSearchViewController with adjustments
    func testDeleteFilm() {
        let id = "someUniqueID"
        saveFilmToDB(imdbID: id)
        
        let fetchRequest:NSFetchRequest<Film> = Film.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbID = %@", id)
        
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
        
        let fetchRequestForDelete: NSFetchRequest<Film> = Film.fetchRequest()
        do {
            let searchRes = try DatabaseController.getContext().fetch(fetchRequestForDelete)
            XCTAssertEqual(searchRes.count, 0)
        } catch {
            print(error)
        }
    }
    
    func testRecommendedVsAllFilmsFromDB() {
        saveFilmToDB(title: "Title 1", year: "2000", runtime: "120 min", genre: "Sci-fi", imdbID: "1", imdbRating: "8.0", lastSeen: NSDate.days(days: -1098)) // Should be recommended (seen > 3 years before and rating 7.0
        saveFilmToDB(title: "Title 2", year: "2000", runtime: "120 min", genre: "Sci-fi", imdbID: "2", imdbRating: "8.9", lastSeen: NSDate.days(days: -1091)) // Shouldn't been recommended seen < 3 years
        saveFilmToDB(title: "Title 3", year: "2000", runtime: "120 min", genre: "Sci-fi", imdbID: "3", imdbRating: "6.9", lastSeen: NSDate.days(days: -1100)) // Shouldn't been recommended rating < 7.0
        saveFilmToDB(title: "Title 4", year: "2000", runtime: "120 min", genre: "Sci-fi", imdbID: "4", imdbRating: "9.2", lastSeen: nil) // Shouldn't been recommended hasn't been seen at all
        
        XCTAssertEqual(1, numberOfRecommendedFilms())
        XCTAssertEqual(4, numberOfAllFilms())
    }
    
    
    func saveFilmToDB(imdbID: String) {
        saveFilmToDB(title: "Title", year: "2000", runtime: "120 min", genre: "Sci-fi", imdbID: imdbID, imdbRating: "8.0", lastSeen: nil)
    }
    
    // Replica of the test that is used in FilmSearchViewController with some adjustments
    func saveFilmToDB(title: String, year: String, runtime: String, genre: String, imdbID: String, imdbRating: String, lastSeen: NSDate?) {
        let fetchRequest:NSFetchRequest<Film> = Film.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbID = %@", imdbID)
        do {
            let searchRes = try DatabaseController.getContext().fetch(fetchRequest)
            if searchRes.count == 0 {
                
                let filmToSave: Film = NSEntityDescription.insertNewObject(forEntityName: "Film", into: DatabaseController.getContext()) as! Film
                
                filmToSave.title = title
                filmToSave.year = year
                filmToSave.runtime = runtime
                filmToSave.genre = genre
                filmToSave.imdbID = imdbID
                filmToSave.imdbRating = imdbRating
                filmToSave.lastSeen = lastSeen
                
                DatabaseController.saveContext()
                
            }
            
        } catch {
            print(error)
        }
    }
    
    func numberOfRecommendedFilms() -> Int {
        var foundFilms = [Film]()
        
        let fetchRequest:NSFetchRequest<Film> = Film.fetchRequest()
        do {
            let searchRes = try DatabaseController.getContext().fetch(fetchRequest)
            
            for result in searchRes as [Film] {

                    if let actualSeenDate = result.lastSeen {
                        if daysBetween(start: actualSeenDate as Date, end: NSDate() as Date) >= 1095 && Double(result.imdbRating!)! > 7.0 {
                            foundFilms.append(result)
                        }
                    }

            }
        } catch {
            print(error)
        }
        
        return foundFilms.count
    }
    
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    func numberOfAllFilms() -> Int {
        var number = 0
        let fetchRequestForDelete: NSFetchRequest<Film> = Film.fetchRequest()
        do {
            let searchRes = try DatabaseController.getContext().fetch(fetchRequestForDelete)
            number = searchRes.count
        } catch {
            print(error)
        }
        
        return number
    }
}

extension NSDate {
    class func days(days:Int) -> NSDate {
        return NSCalendar.current.date(byAdding: Calendar.Component.day, value: days, to: NSDate() as Date)! as NSDate
    }
}
