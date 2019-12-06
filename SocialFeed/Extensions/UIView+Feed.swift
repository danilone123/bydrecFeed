//
//  UIView+Feed.swift
//  SocialFeed
//
//  Created by daniel velasco on 06/12/2019.
//  Copyright © 2019 daniel velasco. All rights reserved.
//
import UIKit

extension UIView {
    func addFullSizeSubview(_ view: UIView) {
        addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
}
