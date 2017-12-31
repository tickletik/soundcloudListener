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
    var year: String
    var cover: String
    
    init(name: String, year: String, cover: String) {
        self.name = name
        self.year = year
        self.cover = cover
    }
}
