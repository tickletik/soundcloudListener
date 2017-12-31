//
//  Album.swift
//  SoundcloudListener
//
//  Created by ronny abraham on 12/31/17.
//  Copyright © 2017 ronny abraham. All rights reserved.
//

import Foundation

class Album {
    var name: String
    var year: Date
    var cover: String
    
    init(name: String, year: Date, cover: String) {
        self.name = name
        self.year = year
        self.cover = cover
    }
}
