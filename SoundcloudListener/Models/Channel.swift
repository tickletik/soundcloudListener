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
}

