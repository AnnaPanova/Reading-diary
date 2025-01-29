//
//  ListOfBooksVC.swift
//  ReadingDiary
//
//  Created by Anna Panova on 16.10.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import UIKit
import CoreData

class ListOfBooksVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addNewBookButton: UIBarButtonItem!
    @IBOutlet weak var showStatisticsButton: UIBarButtonItem!
    
    //  predicate for fetchRequest that will be search book in list
    var predicate: String? = nil
    
    var fetchedResultsController: NSFetchedResultsController<Book>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultController()
    }
    
    //    MARK: Add new Book
    @IBAction func addNewBookAction(_ sender: UIBarButtonItem) {
        let controller = UIAlertController(title: nil, message: "How would you like to add new book?", preferredStyle: .actionSheet)
        
        //  go to SearchBookVC
        let searchOnGoodreadsAction = UIAlertAction(title: "Search on Goodreads", style: .default) { (action) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let searchBookVC = storyboard.instantiateViewController(identifier: "searchBookVC") as! SearchBookVC
            self.navigationController?.pushViewController(searchBookVC, animated: true)
        }
        
        //  go to BookVC
        let addManuallyAction = UIAlertAction(title: "Add manually", style: .default) { (action) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let bookVC = storyboard.instantiateViewController(identifier: "bookVC") as! BookVC
            bookVC.addTitleAndAuthor = true
            self.navigationController?.pushViewController(bookVC, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        controller.addAction(searchOnGoodreadsAction)
        controller.addAction(addManuallyAction)
        controller.addAction(cancelAction)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    //    MARK: Show statistics
    @IBAction func showStatisticsAction(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let statisticsVC = storyboard.instantiateViewController(identifier: "statisticsVC") as! StatisticsVC
        self.navigationController?.pushViewController(statisticsVC, animated: true)
    }
}
