//
//  SocialFeedConnection.swift
//  SocialFeed
//
//  Created by daniel velasco on 01/12/2019.
//  Copyright © 2019 daniel velasco. All rights reserved.
//

import Foundation

class SocialFeedConnection {
    fileprivate struct Constants {
        static let url2 = "https://storage.googleapis.com/cdn-og-test-api/test-task/social/2.json"
        static let url1 = "https://storage.googleapis.com/cdn-og-test-api/test-task/social/1.json"
       }
       
    static func getFeedResults(pageNumber: Int = 1, completion: @escaping ([Feed]?) -> Void) {
           
        let url = URL(string: pageNumber == 1 ? Constants.url1 : Constants.url2)
           var urlRequest = URLRequest(url: url!)
           urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
           urlRequest.httpMethod = "GET"
           
           let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
               
               guard error == nil else {
                   print("error=\(String(describing: error))")
                   return
               }
               
               if let data = data {
                   do {
                       let feeds = try JSONDecoder().decode([Feed].self, from: data)
                       completion(feeds)
                       return
                   } catch {
                       print("feed Parsing Error, class SocialFeedConnection")
                   }
               } else {
                   print("No data recived: class SocialFeedConnection")
               }
           }
           task.resume()
       }
}
