//
//  Feed.swift
//  SocialFeed
//
//  Created by daniel velasco on 01/12/2019.
//  Copyright © 2019 daniel velasco. All rights reserved.
//

struct Author: Decodable {
    enum CodingKeys: String, CodingKey {
        case account
        case name
        case pinctureLink = "picture-link"
    }
    
    let account: String?
    let name: String
    let pictureLink: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        account = try container.decodeIfPresent(String.self, forKey: .account)
        name = try container.decode(String.self, forKey: .name)
        pictureLink = try container.decodeIfPresent(String.self, forKey: .pinctureLink)
    }
}

struct Markup: Decodable {
    enum CodingKeys: String, CodingKey {
           case length
           case link
           case location
    }
    
    let length: Int
    let link: String
    let location: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        length = try container.decode(Int.self, forKey: .length)
        link = try container.decode(String.self, forKey: .link)
        location = try container.decode(Int.self, forKey: .location)
    }
}

struct Text: Decodable {
    enum CodingKeys: String, CodingKey {
              case plain
              case markup
    }
    
    let plain: String
    let markup: [Markup]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        markup = container.feed_decodeOptional([Markup].self, forKey: .markup)
        plain = try container.decode(String.self, forKey: .plain)
    }
}

struct Attachment: Decodable {
    enum CodingKeys: String, CodingKey {
              case pictureLink = "picture-link"
              case width
              case height
    }
    
    let pictureLink: String
    let width: Int
    let height: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pictureLink = try container.decode(String.self, forKey: .pictureLink)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
    }
}

struct Feed: Decodable {
    enum CodingKeys: String, CodingKey {
        case text
        case attachment
        case network
        case link
        case date
        case author
    }
    
    let text: Text
    let attachment: Attachment?
    let author: Author
    let network: String?
    let link: String?
    let date: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(Text.self, forKey: .text)
        attachment = container.feed_decodeOptional(Attachment.self, forKey: .attachment)
        network = try container.decode(String.self, forKey: .network)
        link = try container.decode(String.self, forKey: .link)
        date = try container.decode(String.self, forKey: .date)
        author = try container.decode(Author.self, forKey: .author)
       }
}
