//
//  Album.swift
//  SoundcloudListener
//
//  Created by ronny abraham on 12/31/17.
//  Copyright © 2017 ronny abraham. All rights reserved.
//

import Foundation

class Album: CustomStringConvertible {
    var description: String {
        get {
            return "Album \(artist.name) - \(name)"
        }
    }
    
    var artist: Artist
    var name: String
    var year: String
    var cover: String
    
    var tracks: [Track]
    
    init(artist: Artist, name: String, year: String, cover: String) {
        self.artist = artist
        self.name = name
        self.year = year
        self.cover = cover
        
        self.tracks = []
    }
}
