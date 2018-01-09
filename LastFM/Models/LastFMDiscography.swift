//
//  LastFMAlbum.swift
//  LastFM
//
//  Created by ronny abraham on 1/9/18.
//  Copyright © 2018 ronny abraham. All rights reserved.
//

import Foundation

class LastFMDiscography: Decodable, CustomStringConvertible {
    var description: String {
        get {
            return "LastFMDiscography(name: \(name), images: \(images))"
        }
    }
    
    var name: String
    var images: [LastFMImage]
    
    private enum CodingKeys: String, CodingKey {
        case name
        case images = "image"
    }
    
    func getLastFMImage(size: LastFMImage.Sizes) -> LastFMImage? {
        
        for image in images {
            if image.size == size.rawValue {
                return image
            }
        }
        
        return nil
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        images = try values.decode([LastFMImage].self, forKey: .images)
    }
}


struct TopAlbums: Decodable, CustomStringConvertible {
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

