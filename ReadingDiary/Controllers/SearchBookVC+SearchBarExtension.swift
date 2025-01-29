//
//  SearchBookVC+SearchBarExtension.swift
//  ReadingDiary
//
//  Created by Anna Panova on 17.10.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import UIKit

extension SearchBookVC: UISearchBarDelegate {
    //    MARK: Setup searchBar
    
    //  MARK: Searching function
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //  searching by author or title
        if let textToSearch = searchBar.text {
            if textToSearch != "" {
                Client.shared.searchBookMethod(searchQuery: textToSearch) { (data, error) in
                    if let data = data {
                        //  run parsing
                        self.setupParser(dataToParse: data)
                    } else if let error = error {
                        //  show error alert
                        print("Error while searching Books on Goodreads: \(error)")
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Is there something wrong...", message: "\(error.localizedDescription)", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    //  MARK: Cancel searching function
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        books.removeAll()
        
        // hide the keyboard
        searchBar.endEditing(true)
        
        tableView.reloadData()
    }
    
    // MARK: Hide the keyboard function
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // hide the keyboard
        books.removeAll()
        searchBar.endEditing(true)
    }
}












