//
//  Song.swift
//  LastFM
//
//  Created by ronny abraham on 1/3/18.
//  Copyright © 2018 ronny abraham. All rights reserved.
//

import Foundation

class Track: CustomStringConvertible {
    
    var description: String {
        get {
            let min = Int(time) / 60
            let sec = Int(time) % 60
            
            
            return "\(number). \(name) (\(min):\(sec))"
        }
    }
    
    var album: Album
    var number: Int
    var name: String
    var time: TimeInterval
    
    init(album: Album, number: Int, name: String, time: TimeInterval ) {
        self.album = album
        self.number = number
        self.name = name
        self.time = time
    }
}
