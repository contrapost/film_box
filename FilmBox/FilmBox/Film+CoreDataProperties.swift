//
//  Film+CoreDataProperties.swift
//  FilmBox
//
//  Created by Alexander Shipunov on 20/12/2016.
//  Copyright © 2016 Alexander Shipunov. All rights reserved.
//

import Foundation
import CoreData


extension Film {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Film> {
        return NSFetchRequest<Film>(entityName: "Film");
    }

    @NSManaged public var title: String?
    @NSManaged public var year: String?
    @NSManaged public var runtime: String?
    @NSManaged public var genre: String?
    @NSManaged public var imdbID: String?
    @NSManaged public var imdbRating: String?
    @NSManaged public var lastSeen: NSDate?

}
