//
//  Song.swift
//  LastFM
//
//  Created by ronny abraham on 1/3/18.
//  Copyright © 2018 ronny abraham. All rights reserved.
//

import Foundation

class Track: Decodable, CustomStringConvertible {
    
    var description: String {
        get {
            let duration = Int(duration)
            let min = duration / 60 
            let sec = duration % 60
            return "\(number). \(name) (\(min):\(sec))"
        }
    }

    
    var album: Album

    var name: String
    var duration: TimeInterval
    var number: Int

    enum CodingKeys: String, CodingKey {
        case name
        case duration
        case number = "@attr"
    }
    
    enum AttrKeys: String, CodingKey {
        case rank
    }

    init(album: Album, number: Int, name: String, time: TimeInterval ) {
        self.album = album
        self.number = number
        self.name = name
        self.time = time
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        duration = Int(try values.decode(String.self, forKey: .duration))!
        
        let rankContainer = try values.nestedContainer(keyedBy: AttrKeys.self, forKey: .number )
        let rank = try rankContainer.decode(String.self, forKey: .rank)
        
        number = Int(rank)!
    }
}

struct LastFMTrack: Codable, CustomStringConvertible {
    var description: String {
        get {
            return "LastFMTrack(name: \(name), duration: \(duration), number: \(number))"
        }
    }
    
    var duration: String {
        get {
            let min = Int(seconds / 60)
            let sec = seconds % 60
            
            return "\(min):\(sec)"
        }
    }
    
    let name: String
    let seconds: Int
    let number: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case seconds = "duration"
        case number = "@attr"
    }
    
    enum AttrKeys: String, CodingKey {
        case rank
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        seconds = Int(try values.decode(String.self, forKey: .seconds))!
        
        let rankContainer = try values.nestedContainer(keyedBy: AttrKeys.self, forKey: .number )
        let rank = try rankContainer.decode(String.self, forKey: .rank)
        
        number = Int(rank)!
    }
}
