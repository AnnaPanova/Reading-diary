//
//  SearchBookVC+TableViewExtension.swift
//  ReadingDiary
//
//  Created by Anna Panova on 17.10.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import UIKit
import SafariServices

extension SearchBookVC: UITableViewDelegate, UITableViewDataSource {
    
    //    MARK: Setup tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSerch") as! CustomCellSearch
        
        //  setup coverImage
        if let image = books[indexPath.row].coverImage {
            cell.coverImage.image = image
        } else {
            // setup placeholder
            cell.activityIndicator.startAnimating()
            cell.coverImage.image = UIImage(named: "simpleBookCover")
            
            // loading photo async
            let url = books[indexPath.row].urlImage
            let dataFromUrl = try! Data(contentsOf: url)
            DispatchQueue.main.async {
                cell.activityIndicator.stopAnimating()
                let image = UIImage(data: dataFromUrl)
                cell.coverImage.image = image
                self.books[indexPath.row].coverImage = image
            }
        }
        
        cell.titleLabel.text = books[indexPath.row].title
        cell.authorLabel.text = books[indexPath.row].author
        
        cell.starsFromGoodreadsLabel.text = "Stars from Goodreads: " + books[indexPath.row].starsGoodreads
        
        // the code that will be executed when user tap on the button with link
        cell.openLink = { [unowned self] in
            // in the [unowned self] the 'self' is the viewcontroller
            self.openBookOnGoodreads(link: self.books[indexPath.row].link)
        }
        return cell
    }
    
    //  MARK: Show information about selected book (open BookVC)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bookVC = storyboard.instantiateViewController(identifier: "bookVC") as! BookVC
        
        //  send information about book to the BookVC
        bookVC.book = book
        
        self.navigationController?.pushViewController(bookVC, animated: true)
    }
    
    //  MARK: Open book's link on Goodreads
    func openBookOnGoodreads(link: String) {
        //    check the URL:
        if  let url = URL(string: link) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Is there something wrong...", message: "Sorry, this link is invalid", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    }
}




