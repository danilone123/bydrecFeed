//
//  String+Feed.swift
//  SocialFeed
//
//  Created by daniel velasco on 02/12/2019.
//  Copyright © 2019 daniel velasco. All rights reserved.
//

import Foundation

extension String {
    func buildLocalDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ssZ"
        dateFormatter.calendar = .current
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "EEEE, dd MMMM, yyyy"
        if let dtFormat = dt {
            return dateFormatter.string(from: dtFormat)
        }
        return nil
    }
}
