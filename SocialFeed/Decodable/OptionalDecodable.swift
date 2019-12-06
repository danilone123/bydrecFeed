//
//  OptionalDecodable.swift
//  SocialFeed
//
//  Created by daniel velasco on 01/12/2019.
//  Copyright © 2019 daniel velasco. All rights reserved.
//

import Foundation

protocol OptionalDecodable: KeyedDecodingContainerProtocol {
    func feed_decodeOptional<T>(_ type: T.Type, forKey key: Self.Key) -> T? where T: Decodable
}

extension KeyedDecodingContainer: OptionalDecodable {
    func feed_decodeOptional<T>(_ type: T.Type, forKey key: K) -> T? where T : Decodable {
        do {
            return try decodeIfPresent(type, forKey: key)
        } catch {
            print("feed decoding problem")
            return nil
        }
    }
}
