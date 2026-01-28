//
//  Movie+CoreDataProperties.swift
//  
//
//  Created by 박서연 on 1/28/26.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var movieID: Int64
    @NSManaged public var title: String?
    @NSManaged public var posterPath: String?

}
