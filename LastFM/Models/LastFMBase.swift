//
//  LastFMBase.swift
//  LastFM
//
//  Created by ronny abraham on 1/8/18.
//  Copyright © 2018 ronny abraham. All rights reserved.
//

import Foundation

class LastFMBase: Codable {
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
    
    func debug(_ param: String = "") {
        print(param + name)
        
        if let url = getLastFMImage(size: .small)?.url {
            print("\(param)\(url)")
        }
        print()
    }
    
}
