//
//  Channel.swift
//  SoundcloudListener
//
//  Created by ronny abraham on 12/31/17.
//  Copyright © 2017 ronny abraham. All rights reserved.
//

import Foundation

class Artist {
    var name: String
    var listeners: Int
    var coverURL:String
    
    var discography: [Album]

    
    init(name: String, listeners: Int, coverURL: String) {
        self.name = name
        self.listeners = listeners
        self.coverURL = coverURL
        
        self.discography = []
    }
    
    static var defaultData:[Artist] {
        get {
            var channelArray = [Artist]()
            
            
            let kansas = Artist(name: "Kansas", listeners: 324, coverURL: "Kansas - Point of Know Return.jpg" )
            
            let kansas_know =  Album(artist: kansas, name: "Point of Know Return", year: "1977", cover: "Kansas - Point of Know Return.jpg")
            let kansas_america = Album(artist: kansas, name: "Song for America", year: "1975", cover: "Kansas_-_Song_for_America.jpg")
            let kansas_kansas = Album(artist: kansas, name: "Kansas", year: "1974", cover: "Kansas_-_Kansas.jpg")
            let kansas_overture = Album(artist: kansas, name: "Leftoverture", year: "1976", cover: "Kansas_-_Leftoverture.jpg")
        
            kansas.discography.append(kansas_know)
            kansas.discography.append(kansas_america)
            kansas.discography.append(kansas_kansas)
            kansas.discography.append(kansas_overture)
            
            channelArray.append(kansas)
            
            let redhotchili = Artist(name: "Red Hot Chili Peppers", listeners: 2005, coverURL: "red hot chili peppers.jpg")
            redhotchili.discography.append(Album(artist: redhotchili, name: "The Red Hot Chili Peppers", year: "1984", cover: "RHCP.1984.jpg"))
            redhotchili.discography.append(Album(artist: redhotchili, name: "Freaky Styley", year: "1985", cover: "RHCP.Freakystyleyalbumcover.jpg"))
            redhotchili.discography.append(Album(artist: redhotchili, name: "The Uplift Mofo Party Plan", year: "1987", cover: "RHCP.UpliftMofoCover.jpg"))
            redhotchili.discography.append(Album(artist: redhotchili, name: "Mother's Milk", year: "1989", cover: "RHCP.Mother'sMilkAlbumcover.jpg"))
            redhotchili.discography.append(Album(artist: redhotchili, name: "Blood Sugar Sex Magic", year: "1991", cover: "RHCP.BSSM.jpg"))
            channelArray.append(redhotchili)
            
            
            channelArray.append(Artist(name: "Boston", listeners: 6032, coverURL: "Boston - Dont Look Back.jpg"))
            
            channelArray.append(Artist(name: "Madness", listeners: 230, coverURL: "Madness - One Step Beyond.jpg"))
            
            channelArray.append(Artist(name: "Kook and the Gang", listeners: 783, coverURL: "Kool_and_the_Gang1969.jpg"))
            
            channelArray.append(Artist(name: "The Specials", listeners: 67, coverURL: "Specials uk front.jpg"))
            
            return channelArray
        }
    }
}

