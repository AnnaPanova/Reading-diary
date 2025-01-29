//
//  SearchBookVC.swift
//  ReadingDiary
//
//  Created by Anna Panova on 17.10.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

class SearchBookVC: UIViewController {
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //  array with found on Goodreads books
    var books = [FoundBook]()
    
    //  parameters for temporary save searching results
    var rating = String()
    var elementName = String()
    var bookTitle = String()
    var bookId = String()
    var bookIdArray = [String]()
    var authorName = String()
    var imageURL = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
