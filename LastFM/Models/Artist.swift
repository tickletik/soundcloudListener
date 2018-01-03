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
    
    
    static func seconds(_ min: Int, _ sec: Int) -> Double {
        return Double(min * 60 + sec)
    }
    
    static var defaultData:[Artist] {
        get {
            var channelArray = [Artist]()
            
            
            let kansas = Artist(name: "Kansas", listeners: 324, coverURL: "Kansas - Point of Know Return.jpg" )
            
            let kansas_know =  Album(artist: kansas, name: "Point of Know Return", year: "1977", cover: "Kansas - Point of Know Return.jpg")
            let kansas_america = Album(artist: kansas, name: "Song for America", year: "1975", cover: "Kansas_-_Song_for_America.jpg")
            let kansas_kansas = Album(artist: kansas, name: "Kansas", year: "1974", cover: "Kansas_-_Kansas.jpg")
            let kansas_overture = Album(artist: kansas, name: "Leftoverture", year: "1976", cover: "Kansas_-_Leftoverture.jpg")
            
            kansas_kansas.tracks.append(Song(album: kansas_kansas, track: 1, name: "Can I Tell You", time: seconds(3,32) ))
            kansas_kansas.tracks.append(Song(album: kansas_kansas, track: 2, name: "Bringing It Back", time: seconds(3,33) ))
            kansas_kansas.tracks.append(Song(album: kansas_kansas, track: 3, name: "Lonely Wind", time: seconds(4,16) ))
            kansas_kansas.tracks.append(Song(album: kansas_kansas, track: 4, name: "Belexes", time: seconds(4,23) ))
            kansas_kansas.tracks.append(Song(album: kansas_kansas, track: 5, name: "Journey from Mariabronn", time: seconds(7,55) ))
            kansas_kansas.tracks.append(Song(album: kansas_kansas, track: 6, name: "The Pilgrimage", time: seconds(3,42) ))
            kansas_kansas.tracks.append(Song(album: kansas_kansas, track: 7, name: "Aperçu", time: seconds(9,56) ))
            kansas_kansas.tracks.append(Song(album: kansas_kansas, track: 8, name: "Death of Mother Nature Suite", time: seconds(7,43) ))
            
            kansas_america.tracks.append(Song(album: kansas_america, track: 1, name: "Down the Road", time: seconds(3,43) ))
            kansas_america.tracks.append(Song(album: kansas_america, track: 2, name: "Song for America", time: seconds(10,3) ))
            kansas_america.tracks.append(Song(album: kansas_america, track: 3, name: "Lamplight Symphony", time: seconds(8,17) ))
            kansas_america.tracks.append(Song(album: kansas_america, track: 4, name: "Lonely Street", time: seconds(5,43) ))
            kansas_america.tracks.append(Song(album: kansas_america, track: 5, name: "The Devil Game", time: seconds(5,4) ))
            kansas_america.tracks.append(Song(album: kansas_america, track: 6, name: "Incomudro - Hymn to the Atman", time: seconds(12,11) ))
            
            kansas_know.tracks.append(Song(album: kansas_know, track: 1, name: "Point of Know Return", time: seconds(3,13) ))
            kansas_know.tracks.append(Song(album: kansas_know, track: 2, name: "Paradox", time: seconds(3,50) ))
            kansas_know.tracks.append(Song(album: kansas_know, track: 3, name: "The Spider", time: seconds(2,38) ))
            kansas_know.tracks.append(Song(album: kansas_know, track: 4, name: "Portrait (He Knew)", time: seconds(4,38) ))
            kansas_know.tracks.append(Song(album: kansas_know, track: 5, name: "Closet Chronicles", time: seconds(6, 31) ))
            kansas_know.tracks.append(Song(album: kansas_know, track: 6, name: "Lightning's Hand", time: seconds(4,24) ))
            kansas_know.tracks.append(Song(album: kansas_know, track: 7, name: "Dust in the Wind", time: seconds(3,28) ))
            kansas_know.tracks.append(Song(album: kansas_know, track: 8, name: "Sparks of the Tempest", time: seconds(4,18) ))
            kansas_know.tracks.append(Song(album: kansas_know, track: 9, name: "Nobody's Home", time: seconds(4,40) ))
            kansas_know.tracks.append(Song(album: kansas_know, track: 10, name: "Hopelessly Human", time: seconds(7,17) ))
            
            kansas_overture.tracks.append(Song(album: kansas_overture, track: 1, name: "Carry On Wayward Son", time: seconds(5,23) ))
            kansas_overture.tracks.append(Song(album: kansas_overture, track: 2, name: "The Wall", time: seconds(4,51) ))
            kansas_overture.tracks.append(Song(album: kansas_overture, track: 3, name: "What's on My Mind", time: seconds(3,28) ))
            kansas_overture.tracks.append(Song(album: kansas_overture, track: 4, name: "Miracles Out of Nowhere", time: seconds(6,28) ))
            kansas_overture.tracks.append(Song(album: kansas_overture, track: 5, name: "Opus Insert", time: seconds(4,30) ))
            kansas_overture.tracks.append(Song(album: kansas_overture, track: 6, name: "Questions of My Childhood", time: seconds(3,40) ))
            kansas_overture.tracks.append(Song(album: kansas_overture, track: 7, name: "Cheyenne Anthem", time: seconds(6,55) ))
            kansas_overture.tracks.append(Song(album: kansas_overture, track: 8, name: "Magnum Opus", time: seconds(8,25) ))
            
            
            kansas.discography.append(kansas_kansas)
            kansas.discography.append(kansas_america)
            kansas.discography.append(kansas_know)
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

