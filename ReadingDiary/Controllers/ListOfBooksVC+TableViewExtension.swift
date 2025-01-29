//
//  ListOfBooksVC+TableViewExtension.swift
//  ReadingDiary
//
//  Created by Anna Panova on 16.10.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import UIKit
import CoreData

extension ListOfBooksVC: UITableViewDelegate, UITableViewDataSource {
    
    //    MARK: Setup tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
        
        let bookMO = fetchedResultsController.object(at: indexPath)
        //  setup coverImage
        if let image = bookMO.coverImage {
            DispatchQueue.main.async {
                cell.coverImage.image = UIImage(data: image)
            }
        } else {
            // setup placeholder
            cell.activityIndicator.startAnimating()
            cell.coverImage.image = UIImage(named: "simpleBookCover")
            
            // loading photo async
            if bookMO.urlImage != nil && bookMO.urlImage != "absent" {
                let strDescription = String(describing: bookMO.urlImage!)
                if let url = URL(string: strDescription) {
                    print("URL: \(url)")
                    let dataFromUrl = try! Data(contentsOf: url)
                    let image = UIImage(data: dataFromUrl)
                    DispatchQueue.main.async {
                        cell.coverImage.image = image
                        bookMO.coverImage = dataFromUrl
                        PersistenceService.saveContext()
                    }
                }
            }
            cell.activityIndicator.stopAnimating()
        }
        
        //  setup title and author
        cell.titleLabel.text = bookMO.title!
        cell.authorLabel.text = bookMO.author!
        
        //  check  is reading in process or finished?
        if bookMO.startOfReading != nil && bookMO.endOfReading != nil {
            // we have both dates - book is readed
            cell.readedLabel.text = "Readed"
        } else if  bookMO.startOfReading != nil && bookMO.endOfReading == nil {
            // we have just start of reading - book is in reading process
            cell.readedLabel.text = "In process"
        } else {
            // we don't have dates - book will be in status "want to read"
            cell.readedLabel.text = "Want to read"
        }
        
        //  check are Goodreads's stars exist?
        if bookMO.starsGoodreads != nil {
            cell.starsFromGoodreadsLabel.text = "Stars from Goodreads: " + bookMO.starsGoodreads!
        } else {
            cell.starsFromGoodreadsLabel.text = "Goodreads's stars are absent"
        }
        
        //  check are my stars exist?
        if bookMO.myStars != nil {
            cell.myStarsLabel.text = "My stars: " + bookMO.myStars!
        } else {
            cell.myStarsLabel.text = "My stars are absent"
        }
        return cell
    }
    
    //  MARK: Delete book action
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteBook(at: indexPath)
        default: () // Unsupported
        }
    }
    
    //  Delete book from storage
    func deleteBook(at indexPath: IndexPath) {
        let bookToDelete = fetchedResultsController.object(at: indexPath)
        PersistenceService.context.delete(bookToDelete)
        PersistenceService.saveContext()
    }
    
    //  MARK: Go to tne BookVC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookToOpen = fetchedResultsController.object(at: indexPath)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bookVC = storyboard.instantiateViewController(identifier: "bookVC") as! BookVC
        
        // send information about selected book to the BookVC
        bookVC.bookMO = bookToOpen
        self.navigationController?.pushViewController(bookVC, animated: true)
    }
}
