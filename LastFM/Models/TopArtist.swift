//
//  LastFMArtist.swift
//  LastFM
//
//  Created by ronny abraham on 1/8/18.
//  Copyright © 2018 ronny abraham. All rights reserved.
//

import Foundation

struct TopArtist: Decodable, CustomStringConvertible {
    var description: String {
        get {
            var desc = "[ "
            for artist in artists {
                desc += "\(artist), "
            }
            
            desc.remove(at: desc.index(desc.endIndex, offsetBy:-2))
            desc += "]"
            return desc
        }
    }
    
    let artists: [Artist]
    
    enum CodingKeys: String, CodingKey {
        case artists = "artist"
    }
    
    enum ContainerKeys: String, CodingKey {
        case container = "topartists"
    }
    
    init(from decoder: Decoder) throws {
        let topcontainer = try decoder.container(keyedBy: ContainerKeys.self)
        
        let values = try topcontainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .container)
        artists = try values.decode([Artist].self, forKey: .artists)
    }
}
