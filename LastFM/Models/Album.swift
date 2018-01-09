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
    var cover: Cover 
    
    var tracks: [Track] = []
    
    init(artist: Artist, name: String, year: String, cover: Cover) {
        self.artist = artist
        self.name = name
        self.year = year
        self.cover = cover
    }
}

class LastFMAlbum: LastFMBase, CustomStringConvertible {
    var description: String {
        get {
            return "LastFMAlbum()"
        }
    }
    
    let tracks: [Track]
    
    enum CodingKeys: String, CodingKey {
        case tracks
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let tracktest = try values.decode([String: [Track]].self, forKey: .tracks)
        tracks = tracktest["track"]!
        
        try super.init(from: decoder)
    }
    
}
