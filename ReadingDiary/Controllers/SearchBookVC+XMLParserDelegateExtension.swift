//
//  SearchBookVC+XMLParserDelegateExtension.swift
//  ReadingDiary
//
//  Created by Anna Panova on 24.10.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import UIKit
import SafariServices

extension SearchBookVC: XMLParserDelegate {
    //  MARK: Setup parser and parsingMethods
    
    //  MARK: Setup parser
    func setupParser(dataToParse: Data) {
        let parser = XMLParser(data: dataToParse)
        parser.delegate = self
        parser.parse()
    }
    
    //  MARK: Searching start elements in xml file
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "work" {
            print("didStartElement with name: \(elementName)")
        }
        
        if elementName == "average_rating" {
            print("didStartElement with name: \(elementName)")
            rating = String()
        }
        
        if elementName == "best_book" {
            print("didStartElement with name: \(elementName)")
        }
        
        if elementName == "id" {
            print("didStartElement with name: \(elementName)")
            bookId = String()
        }
        
        if elementName == "title" {
            print("didStartElement with name: \(elementName)")
            bookTitle = String()
        }
        
        if elementName == "name" {
            print("didStartElement with name: \(elementName)")
            authorName = String()
        }
        
        if elementName == "image_url" {
            print("didStartElement with name: \(elementName)")
            imageURL = String()
        }
        
        self.elementName = elementName
        print("   self.elementName = elementName: \(elementName)")
    }
    
    //  MARK: Setup search result for temporary save
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            if self.elementName == "average_rating" {
                rating += data
            } else if self.elementName == "id" {
                bookId += data
                bookIdArray.append(bookId)
            } else if self.elementName == "title" {
                bookTitle += data
            } else if self.elementName == "name" {
                authorName += data
            } else if self.elementName == "image_url" {
                imageURL += data
            }
        }
    }
    
    //  MARK: Show results in tableView
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "work" {
            let urlImage = URL(string: imageURL)
            
            let book = FoundBook(author: authorName, title: bookTitle, coverImage: nil, urlImage: urlImage!, id: bookIdArray[1], starsGoodreads: rating)
            books.append(book)
            bookIdArray.removeAll()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //  MARK: Print number of found books
    func parserDidEndDocument(_ parser: XMLParser) {
        print("WHAT WE FOUND: \(books.count)")
    }
}
