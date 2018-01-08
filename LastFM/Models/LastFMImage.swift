//
//  CodableTest.swift
//  LastFM
//
//  Created by ronny abraham on 1/8/18.
//  Copyright © 2018 ronny abraham. All rights reserved.
//

import Foundation

struct LastFMImage: Codable, CustomStringConvertible {
    
    var description: String {
        get {
            return "LastFMImage(size: \(size), url: \(url))"
        }
    }
    
    var size: String
    var url: URL
    
    enum Sizes: String {
        case small
        case medium
        case large
        case extralarge
        case mega
    }
    
    enum CodingKeys: String, CodingKey {
        case url = "#text"
        case size
    }
}
