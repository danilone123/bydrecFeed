//
//  FeedInformationCell.swift
//  SocialFeed
//
//  Created by daniel velasco on 01/12/2019.
//  Copyright © 2019 daniel velasco. All rights reserved.
//

import UIKit

class FeedInformationCell: UITableViewCell {
    fileprivate struct Constants {
        static let widthCell: CGFloat = 150.0
        static let fontSize: CGFloat = 14.0
        static let fontName = "Helvetica"
    }
    
    @IBOutlet weak var stackViewLabels: UIStackView!
    //@IBOutlet fileprivate weak var accountLabel: UILabel!
    //@IBOutlet fileprivate weak var name: UILabel!
    @IBOutlet fileprivate weak var networkLabel: UILabel!
    @IBOutlet fileprivate weak var textPost: UITextView!
    @IBOutlet fileprivate weak var authorImage: UIImageView!
    @IBOutlet fileprivate weak var postImage: UIImageView!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    @IBOutlet fileprivate weak var widthPostImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var postRatioConstraint: NSLayoutConstraint!
    
    override  func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureWithFeed(feedInformation: Feed) {
        labelHeader(name: feedInformation.author.name, accountName: feedInformation.author.account)
        networkLabel.text = feedInformation.network
        authorImage.download(from: feedInformation.author.pictureLink ?? "")
        buildLinkText(text: feedInformation.text)
        
        //logic to build aspect ratio
        if let width = feedInformation.attachment?.width, let height = feedInformation.attachment?.height, let imageUrl = feedInformation.attachment?.pictureLink {
            widthPostImageConstraint.constant = Constants.widthCell
            let newConstraint = postRatioConstraint.constraintWithMultiplier(CGFloat(width)/CGFloat(height))
            postImage.removeConstraint(postRatioConstraint)
            postImage.addConstraint(newConstraint)
            self.postRatioConstraint = newConstraint
            postImage.download(from: imageUrl)
        } else {
            widthPostImageConstraint.constant = 0
        }
        dateLabel.text = feedInformation.date?.buildLocalDate()
    }
    
    fileprivate func buildLinkText(text: Text) {
        let attributedString = NSMutableAttributedString(string: text.plain)
        
        if let markupList = text.markup {
            for markup in markupList {
                attributedString.setAttributes([.link: markup.link], range: NSMakeRange(markup.location, markup.length))
            }
        }
        
        self.textPost.attributedText = attributedString
        self.textPost.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
        ]
    }
    
    fileprivate func labelHeader(name: String, accountName: String?) {
        for stackElement in stackViewLabels.subviews {
            stackElement.removeFromSuperview()
        }
        if let accountText = accountName {
            stackViewLabels.addArrangedSubview(buildLabel(text: "@" + accountText))
        }
        stackViewLabels.addArrangedSubview(buildLabel(text: name))
    }
    
    fileprivate func buildLabel(text: String) -> UILabel {
        let labelView = UILabel()
        labelView.text = text
        labelView.font = UIFont(name: Constants.fontName, size: Constants.fontSize)
        labelView.textColor = UIColor.black
        labelView.textAlignment = .left
        labelView.numberOfLines = 1
        return labelView
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
