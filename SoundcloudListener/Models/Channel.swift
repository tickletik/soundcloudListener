//
//  Channel.swift
//  SoundcloudListener
//
//  Created by ronny abraham on 12/31/17.
//  Copyright © 2017 ronny abraham. All rights reserved.
//

import Foundation

class Channel {
    var artist: String
    var listeners: Int
    var coverURL:String

    init(artist: String, listeners: Int, coverURL: String) {
        self.artist = artist
        self.listeners = listeners
        self.coverURL = coverURL
    }
    
    static var channelData:[Channel] {
        get {
            var channelArray = [Channel]()
            
            channelArray.append(Channel(artist: "Kansas", listeners: 324, coverURL: "Kansas - Point of Know Return.jpg" ))
            
            channelArray.append(Channel(artist: "Red Hot Chili Peppers", listeners: 2005, coverURL: "red hot chili peppers.jpg"))
            
            channelArray.append(Channel(artist: "Boston", listeners: 6032, coverURL: "Boston - Dont Look Back.jpg"))
            
            channelArray.append(Channel(artist: "Madness", listeners: 230, coverURL: "Madness - One Step Beyond.jpg"))
            
            channelArray.append(Channel(artist: "Kook and the Gang", listeners: 783, coverURL: "Kool_and_the_Gang1969.jpg"))
            
            channelArray.append(Channel(artist: "The Specials", listeners: 67, coverURL: "Specials uk front.jpg"))
            
            return channelArray
        }
    }
}

