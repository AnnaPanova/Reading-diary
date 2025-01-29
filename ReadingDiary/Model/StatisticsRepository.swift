//
//  StatisticsRepository.swift
//  ReadingDiary
//
//  Created by Anna Panova on 01.11.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import Foundation

//  MARK: Repository for storage statistics
class StatisticsRepository {
    
    private var bookDict: [String: Double]
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        bookDict = userDefaults.dictionary(forKey: "bookDict") as? [String : Double] ?? [:]
    }
    
    // MARK: Save function
    func save() {
        userDefaults.set(bookDict,forKey: "bookDict")
    }
    
    //    MARK: Add new book
    //   id - unique combination author and title for checking: does the book exist in Storage(than we rewrite duration of reading) or not (add new book and duration)
    func addNewBook(id: String, duration: Double) {
        bookDict[id] = duration
    }
    
    //    MARK: Calculate average duration
    func getAverageDuration() -> Int {
        if !bookDict.isEmpty {
            var totalDuration = 0.0
            for (id, duration) in bookDict {
                totalDuration += duration
            }
            return Int(totalDuration) / bookDict.count
        }
        return 0
    }
    
    //    MARK: Get number of readed books
    func getNumberOfReadedBooks() -> Int {
        return bookDict.count
    }
}

