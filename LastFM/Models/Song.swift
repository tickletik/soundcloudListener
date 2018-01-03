//
//  Song.swift
//  LastFM
//
//  Created by ronny abraham on 1/3/18.
//  Copyright © 2018 ronny abraham. All rights reserved.
//

import Foundation

class Song: CustomStringConvertible {
    
    var description: String {
        get {
            return "\(track). \(name) (\(time)"
        }
    }
    
    var album: Album
    var track: Int
    var name: String
    var time: TimeInterval
    
    init(album: Album, track: Int, name: String, time: TimeInterval ) {
        self.album = album
        self.track = track
        self.name = name
        self.time = time
    }
}
