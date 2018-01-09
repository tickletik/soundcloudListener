//
//  LastFMAlbum.swift
//  LastFM
//
//  Created by ronny abraham on 1/9/18.
//  Copyright © 2018 ronny abraham. All rights reserved.
//

import Foundation

class LastFMDiscography: LastFMBase, CustomStringConvertible {
    var description: String {
        get {
            return "LastFMDiscography(name: \(name), images: \(images))"
        }
    }
}


struct TopAlbums: Codable, CustomStringConvertible {
    var description: String {
        get {
            var desc = "[ "
            for album in albums {
                desc += "\(album), "
            }
            
            desc.remove(at: desc.index(desc.endIndex, offsetBy:-2))
            desc += "]"
            return desc
        }
    }
    
    let albums: [LastFMDiscography]
    
    enum CodingKeys: String, CodingKey {
        case albums = "album"
    }
    
    enum ContainerKeys: String, CodingKey {
        case container = "topalbums"
    }
    
    init(from decoder: Decoder) throws {
        let topcontainer = try decoder.container(keyedBy: ContainerKeys.self)
        
        let values = try topcontainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .container)
        albums = try values.decode([LastFMDiscography].self, forKey: .albums)
    }
}
