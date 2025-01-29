//
//  ListOfBooksVC+SearchBarExtension.swift
//  ReadingDiary
//
//  Created by Anna Panova on 16.10.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import UIKit

extension ListOfBooksVC: UISearchBarDelegate {
    
    //  MARK: Setup searchBar
    
    //  MARK: Searching function
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        // search on the list by the title or author of book
        if let textToSearch = searchBar.text {
            if textToSearch != "" {
                //  run fetchRequest with predicate
                performSearch(textForSearching: textToSearch.lowercased())
                
                self.addNewBookButton.isEnabled = false
                self.showStatisticsButton.isEnabled = false
                self.tableView.reloadData()
            }
        }
    }
    
    //  MARK: Cancel searching function
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        predicate = nil
        
        //  run fetchRequest without predicate
        setupFetchedResultController()
        
        addNewBookButton.isEnabled = true
        showStatisticsButton.isEnabled = true
        tableView.reloadData()
        
        // hide the keyboard
        searchBar.endEditing(true)
    }
    
    //  MARK: Hide the keyboard function
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // hide the keyboard
        searchBar.endEditing(true)
    }
}
