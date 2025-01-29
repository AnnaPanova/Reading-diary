//
//  Book+CoreDataClass.swift
//  
//
//  Created by Anna Panova on 24.10.19.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(Book)
public class Book: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }
    
    @NSManaged public var author: String?
    @NSManaged public var coverImage: Data?
    @NSManaged public var endOfReading: Date?
    @NSManaged public var id: String?
    @NSManaged public var myStars: String?
    @NSManaged public var review: String?
    @NSManaged public var starsGoodreads: String?
    @NSManaged public var startOfReading: Date?
    @NSManaged public var title: String?
    @NSManaged public var urlImage: String?
    
    // Generate string for book's link on Goodreads
    var link: String? {
        guard let id = id else  { return nil }
        let string = Constants.UrlForLink + id + "." + title!
        return string.replacingOccurrences(of: " ", with: "%20")
    }
}
