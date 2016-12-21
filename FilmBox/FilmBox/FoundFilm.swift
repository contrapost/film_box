//
//  FoundFilm.swift
//  FilmBox
//
//  Created by Alexander Shipunov on 20/12/2016.
//  Copyright © 2016 Alexander Shipunov. All rights reserved.
//

import Foundation

class FoundFilm {
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
