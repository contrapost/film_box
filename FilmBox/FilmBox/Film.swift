//
//  Movie.swift
//  FilmBox
//
//  Created by Alexander Shipunov on 19/12/2016.
//  Copyright © 2016 Alexander Shipunov. All rights reserved.
//

import Foundation

class Film {
    let title: String
    let year: String
    let runtime: String
    let genre: String
    let imdbID: String
    let imdbRating: String
    let lastSeen: Date?
    
    init(title: String, year: String, runtime: String, genre: String, imdbID: String, imdbRating: String) {
    self.title = title
    self.year = year
    self.runtime = runtime
    self.genre = genre
    self.imdbID = imdbID
    self.imdbRating = imdbRating
    self.lastSeen = nil
    }
    
}
