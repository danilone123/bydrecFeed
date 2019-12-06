//
//  UIImageView+Feed.swift
//  SocialFeed
//
//  Created by daniel velasco on 01/12/2019.
//  Copyright © 2019 daniel velasco. All rights reserved.
//

import UIKit

extension UIImageView {
    fileprivate struct Constants {
        static let defaultImage = "defaultCar"
    }
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func download(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        //set default image
        self.image = UIImage(named: Constants.defaultImage)
        guard let url = URL(string: link) else {
            return
        }
        downloaded(from: url, contentMode: mode)
    }
}
