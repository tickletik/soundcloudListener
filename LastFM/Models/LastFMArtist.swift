//
//  LastFMArtist.swift
//  LastFM
//
//  Created by ronny abraham on 1/8/18.
//  Copyright © 2018 ronny abraham. All rights reserved.
//

import Foundation

class LastFMArtist: LastFMBase, CustomStringConvertible {
    var description: String {
        get {
            return "LastFMArtist(name: \(name), listeners: \(listeners), images: \(images))"
        }
    }
    
    var listeners: Int
    
    enum CodingKeys: String, CodingKey {
        case listeners
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let listeners = try values.decode(String.self, forKey: .listeners)
        self.listeners = Int(listeners)!
        
        try super.init(from: decoder)
    }
}


struct TopArtist: Codable, CustomStringConvertible {
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
    
    let artists: [LastFMArtist]
    
    enum CodingKeys: String, CodingKey {
        case artists = "artist"
    }
    
    enum ContainerKeys: String, CodingKey {
        case container = "topartists"
    }
    
    init(from decoder: Decoder) throws {
        let topcontainer = try decoder.container(keyedBy: ContainerKeys.self)
        
        let values = try topcontainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .container)
        artists = try values.decode([LastFMArtist].self, forKey: .artists)
    }
}
