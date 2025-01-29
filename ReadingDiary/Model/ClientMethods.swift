//
//  ClientMethods.swift
//  ReadingDiary
//
//  Created by Anna Panova on 18.10.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import UIKit

extension Client {
    
    //    MARK: Search book on Goodreads
    func searchBookMethod(searchQuery: String, completionHandler: @escaping (_ data: Data?,_ error: Error?) -> Void) {
        // set parameters for Url:
        let parameters = [
        Constants.GoodreadsParameterKeys.key: Constants.GoodreadsParameterValues.myKey,
        Constants.GoodreadsParameterKeys.query: searchQuery
        ]
        
        // create url
        let url = goodreadsUrlFromParameters(parameters: parameters)
        
        // request
        let request = URLRequest(url: url)
        
        // session
        let session = URLSession.shared
        
        //  task
        let task = session.dataTask(with: request) {(data, request, error) in
            
            // Was there an error?
            guard (error == nil) else {
                print("There was an error with your request Searching Books: \(error!)")
                completionHandler(nil, error)
                return
            }
            
            // Check for returned data
            guard let data = data else {
                print("Request returned no data")
                return
            }
            completionHandler(data, nil)
        }
        task.resume()
    }
    
    // MARK: Creating URL from parameters
    func goodreadsUrlFromParameters(parameters: [String:String]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.APIScheme
        components.host = Constants.APIHost
        components.path = Constants.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let urlQueryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(urlQueryItem)
        }
        return components.url!
    }
}
