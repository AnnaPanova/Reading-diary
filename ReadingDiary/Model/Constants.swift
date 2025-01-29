//
//  Constants.swift
//  ReadingDiary
//
//  Created by Anna Panova on 18.10.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import Foundation

struct Constants {
    
    static let APIScheme = "https"
    static let APIHost = "www.goodreads.com"
    static let APIPath = "/search.xml"
    static let UrlForLink = "https://www.goodreads.com/book/show/"
    
    struct GoodreadsParameterKeys {
        static let key = "key"
        //   for this key we will take value(query) from the searchBar.text on the SearchBookVC
        static let query = "q"
    }
    
    struct GoodreadsParameterValues {
        static let myKey = "8iR9CBfdESvGTjAYmw05vw"
    }
}

