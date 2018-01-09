//
//  Album.swift
//  SoundcloudListener
//
//  Created by ronny abraham on 12/31/17.
//  Copyright © 2017 ronny abraham. All rights reserved.
//

import Foundation

class Album: Decodable, CustomStringConvertible {
    var description: String {
        get {
            return "Album \(String(describing: artist?.name)) - \(name)"
        }
    }
    
    var artist: Artist?
    var images: [LastFMImage]?

    var name: String
    var cover: Cover 
    var tracks: [Track] = []

    enum CodingKeys: String, CodingKey {
        case name
        case cover = "image"
        case tracks
    }
    
    init(artist: Artist, name: String, cover: Cover) {
        self.artist = artist
        self.name = name
        self.cover = cover
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try values.decode(String.self, forKey: .name)

        let tracktest = try values.decode([String: [Track]].self, forKey: .tracks)
        tracks = tracktest["track"]!

        images = try values.decode([LastFMImage].self, forKey: .cover)
        let url = Artist.extractImageURL(images: images!, size: .medium)
        self.cover = .url(url!)
    }
}

extension Album {
    static func extractImageURL(images: [LastFMImage], size: LastFMImage.Sizes) -> URL? {
        
        for image in images {
            if image.size == size.rawValue {
                return image.url
            }
        }
        
        return nil
    }
}
