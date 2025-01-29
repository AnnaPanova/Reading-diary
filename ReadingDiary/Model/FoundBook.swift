//
//  FoundBook.swift
//  ReadingDiary
//
//  Created by Anna Panova on 27.10.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import UIKit

// Struct for parsing results from xml-file from Goodreads.

struct FoundBook {
    let author: String
    let title: String
    var coverImage: UIImage?
    let urlImage: URL
    let id: String
    let starsGoodreads: String
    
    // Generate string for book's link on Goodreads
    var link: String {
        let string = Constants.UrlForLink + id + "." + title
        let stringForURL = string.replacingOccurrences(of: " ", with: "%20")
        return stringForURL
    }
}





