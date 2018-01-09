//
//  Channel.swift
//  SoundcloudListener
//
//  Created by ronny abraham on 12/31/17.
//  Copyright © 2017 ronny abraham. All rights reserved.
//

import Foundation

enum Cover {
    case named(String)
    case url(URL)
    
    func value() -> Any {
        switch self {
        case .named(let value):
            return value
        case .url(let value):
            return value
        }
    }
}

class Artist: Decodable, CustomStringConvertible {
    
    var description: String {
        get {
            return "Artist(name: \(name), listeners: \(listeners), cover: \(String(describing: cover)))"
        }
    }
    
    var name: String
    var listeners: Int
    var cover: Cover
    
    var discography: [Album] = []
    var images: [LastFMImage]?

    private enum CodingKeys: String, CodingKey {
        case name
        case cover = "image"
        case listeners
    }
    
    init(name: String, listeners: Int, cover: Cover) {
        self.name = name
        self.listeners = listeners
        
        self.cover = cover
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try values.decode(String.self, forKey: .name)
        self.listeners = Int(try values.decode(String.self, forKey: .listeners))!

        images = try values.decode([LastFMImage].self, forKey: .cover)
        let url = Artist.extractImageURL(images: images!, size: .medium)
        self.cover = .url(url!)
    }
    
    static func seconds(_ min: Int = 0, _ sec: Int) -> Int {
        return min * 60 + sec
    }
}

extension Artist {
    static func extractImageURL(images: [LastFMImage], size: LastFMImage.Sizes) -> URL? {
        
        for image in images {
            if image.size == size.rawValue {
                return image.url
            }
        }
        
        return nil
    }
}


extension Artist {
    
    static var defaultData:[Artist] {
        get {
            var channelArray = [Artist]()
            
            let kansas = Artist(name: "Kansas", listeners: 324, cover: .named("Kansas - Point of Know Return.jpg") )
            
            let kansas_know =  Album(artist: kansas, name: "Point of Know Return", cover: .named("Kansas - Point of Know Return.jpg"))
            let kansas_america = Album(artist: kansas, name: "Song for America", cover: .named("Kansas_-_Song_for_America.jpg"))
            let kansas_kansas = Album(artist: kansas, name: "Kansas", cover: .named("Kansas_-_Kansas.jpg"))
            let kansas_overture = Album(artist: kansas, name: "Leftoverture", cover: .named("Kansas_-_Leftoverture.jpg"))
            
            kansas_kansas.tracks.append(Track(album: kansas_kansas, number: 1, name: "Can I Tell You", duration: seconds(3,32) ))
            kansas_kansas.tracks.append(Track(album: kansas_kansas, number: 2, name: "Bringing It Back", duration: seconds(3,33) ))
            kansas_kansas.tracks.append(Track(album: kansas_kansas, number: 3, name: "Lonely Wind", duration: seconds(4,16) ))
            kansas_kansas.tracks.append(Track(album: kansas_kansas, number: 4, name: "Belexes", duration: seconds(4,23) ))
            kansas_kansas.tracks.append(Track(album: kansas_kansas, number: 5, name: "Journey from Mariabronn", duration: seconds(7,55) ))
            kansas_kansas.tracks.append(Track(album: kansas_kansas, number: 6, name: "The Pilgrimage", duration: seconds(3,42) ))
            kansas_kansas.tracks.append(Track(album: kansas_kansas, number: 7, name: "Aperçu", duration: seconds(9,56) ))
            kansas_kansas.tracks.append(Track(album: kansas_kansas, number: 8, name: "Death of Mother Nature Suite", duration: seconds(7,43) ))
            
            kansas_america.tracks.append(Track(album: kansas_america, number: 1, name: "Down the Road", duration: seconds(3,43) ))
            kansas_america.tracks.append(Track(album: kansas_america, number: 2, name: "Song for America", duration: seconds(10,3) ))
            kansas_america.tracks.append(Track(album: kansas_america, number: 3, name: "Lamplight Symphony", duration: seconds(8,17) ))
            kansas_america.tracks.append(Track(album: kansas_america, number: 4, name: "Lonely Street", duration: seconds(5,43) ))
            kansas_america.tracks.append(Track(album: kansas_america, number: 5, name: "The Devil Game", duration: seconds(5,4) ))
            kansas_america.tracks.append(Track(album: kansas_america, number: 6, name: "Incomudro - Hymn to the Atman", duration: seconds(12,11) ))
            
            kansas_know.tracks.append(Track(album: kansas_know, number: 1, name: "Point of Know Return", duration: seconds(3,13) ))
            kansas_know.tracks.append(Track(album: kansas_know, number: 2, name: "Paradox", duration: seconds(3,50) ))
            kansas_know.tracks.append(Track(album: kansas_know, number: 3, name: "The Spider", duration: seconds(2,38) ))
            kansas_know.tracks.append(Track(album: kansas_know, number: 4, name: "Portrait (He Knew)", duration: seconds(4,38) ))
            kansas_know.tracks.append(Track(album: kansas_know, number: 5, name: "Closet Chronicles", duration: seconds(6, 31) ))
            kansas_know.tracks.append(Track(album: kansas_know, number: 6, name: "Lightning's Hand", duration: seconds(4,24) ))
            kansas_know.tracks.append(Track(album: kansas_know, number: 7, name: "Dust in the Wind", duration: seconds(3,28) ))
            kansas_know.tracks.append(Track(album: kansas_know, number: 8, name: "Sparks of the Tempest", duration: seconds(4,18) ))
            kansas_know.tracks.append(Track(album: kansas_know, number: 9, name: "Nobody's Home", duration: seconds(4,40) ))
            kansas_know.tracks.append(Track(album: kansas_know, number: 10, name: "Hopelessly Human", duration: seconds(7,17) ))
            
            kansas_overture.tracks.append(Track(album: kansas_overture, number: 1, name: "Carry On Wayward Son", duration: seconds(5,23) ))
            kansas_overture.tracks.append(Track(album: kansas_overture, number: 2, name: "The Wall", duration: seconds(4,51) ))
            kansas_overture.tracks.append(Track(album: kansas_overture, number: 3, name: "What's on My Mind", duration: seconds(3,28) ))
            kansas_overture.tracks.append(Track(album: kansas_overture, number: 4, name: "Miracles Out of Nowhere", duration: seconds(6,28) ))
            kansas_overture.tracks.append(Track(album: kansas_overture, number: 5, name: "Opus Insert", duration: seconds(4,30) ))
            kansas_overture.tracks.append(Track(album: kansas_overture, number: 6, name: "Questions of My Childhood", duration: seconds(3,40) ))
            kansas_overture.tracks.append(Track(album: kansas_overture, number: 7, name: "Cheyenne Anthem", duration: seconds(6,55) ))
            kansas_overture.tracks.append(Track(album: kansas_overture, number: 8, name: "Magnum Opus", duration: seconds(8,25) ))
            
            
            kansas.discography.append(kansas_kansas)
            kansas.discography.append(kansas_america)
            kansas.discography.append(kansas_know)
            kansas.discography.append(kansas_overture)
            
            channelArray.append(kansas)
            
            
            let kool = Artist(name: "Kook and the Gang", listeners: 783, cover: .named("Kool_and_the_Gang1969.jpg"))
            
            let kool_kool = Album(artist: kool, name: "Koll and the Gang", cover: .named("Kool_and_the_Gang1969.jpg"))
            let kool_message = Album(artist: kool, name: "Music Is the Message", cover: .named("Music_Is_The_Message1972.jpg"))
            let kool_times = Album(artist: kool, name: "Good Times", cover: .named("Good_Times1972.jpg"))
            
            kool_kool.tracks.append(Track(album: kool_kool, number: 1, name: "Kool & The Gang", duration: seconds(2, 54)))
            kool_kool.tracks.append(Track(album: kool_kool, number: 2, name: "Breeze & Soul", duration: seconds(5, 29)))
            kool_kool.tracks.append(Track(album: kool_kool, number: 3, name: "Chocolate Buttermilk", duration: seconds(2, 14)))
            kool_kool.tracks.append(Track(album: kool_kool, number: 4, name: "Sea of Tranquility", duration: seconds(3, 34)))
            kool_kool.tracks.append(Track(album: kool_kool, number: 5, name: "Give it Up", duration: seconds(3, 40)))
            kool_kool.tracks.append(Track(album: kool_kool, number: 6, name: "Since I Lost My Baby", duration: seconds(2, 8)))
            kool_kool.tracks.append(Track(album: kool_kool, number: 7, name: "Kool's Back Again", duration: seconds(2, 48)))
            kool_kool.tracks.append(Track(album: kool_kool, number: 8, name: "The Gang's Back Again", duration: seconds(2, 46)))
            kool_kool.tracks.append(Track(album: kool_kool, number: 9, name: "Raw Hamburger", duration: seconds(3, 36)))
            kool_kool.tracks.append(Track(album: kool_kool, number: 10, name: "Let The Music Take Your Mind", duration: seconds(2, 58)))
            
            kool_message.tracks.append(Track(album: kool_message, number: 1, name: "Music Is the Message", duration: seconds(5, 18)))
            kool_message.tracks.append(Track(album: kool_message, number: 2, name: "Electric Frog (Part 1)", duration: seconds(3, 43)))
            kool_message.tracks.append(Track(album: kool_message, number: 3, name: "Electric Frog (Part 2)", duration: seconds(3, 2)))
            kool_message.tracks.append(Track(album: kool_message, number: 4, name: "Soul Vibrations", duration: seconds(4, 39)))
            
            kool_message.tracks.append(Track(album: kool_message, number: 5, name: "Love the Life You Live (part 1)", duration: seconds(3, 1)))
            kool_message.tracks.append(Track(album: kool_message, number: 6, name: "Love the Life You Live (part 2)", duration: seconds(2, 48)))
            kool_message.tracks.append(Track(album: kool_message, number: 7, name: "Stop, Look, Listen (To Your Heart)", duration: seconds(3, 26)))
            kool_message.tracks.append(Track(album: kool_message, number: 8, name: "Blowin' with the Wind", duration: seconds(2, 31)))
            kool_message.tracks.append(Track(album: kool_message, number: 9, name: "Funky Granny", duration: seconds(5, 55)))
            
            kool_times.tracks.append(Track(album: kool_times, number: 1, name: "Good Times", duration: seconds(4, 16)))
            kool_times.tracks.append(Track(album: kool_times, number: 2, name: "Country Junky", duration: seconds(2, 55)))
            kool_times.tracks.append(Track(album: kool_times, number: 3, name: "Wild Is Love", duration: seconds(3, 24)))
            kool_times.tracks.append(Track(album: kool_times, number: 4, name: "North, East, South, West", duration: seconds(3, 38)))
            kool_times.tracks.append(Track(album: kool_times, number: 5, name: "Making Merry Music", duration: seconds(3, 4)))
            kool_times.tracks.append(Track(album: kool_times, number: 6, name: "I Remember John W. Coltrane", duration: seconds(4, 2)))
            kool_times.tracks.append(Track(album: kool_times, number: 7, name: "Rated X", duration: seconds(4, 2)))
            kool_times.tracks.append(Track(album: kool_times, number: 8, name: "Father, Father", duration: seconds(5, 37)))
            
            kool.discography.append(kool_kool)
            kool.discography.append(kool_message)
            kool.discography.append(kool_times)
            channelArray.append(kool)
            
            let redhotchili = Artist(name: "Red Hot Chili Peppers", listeners: 2005, cover: .named("red hot chili peppers.jpg"))
            
            redhotchili.discography.append(Album(artist: redhotchili, name: "The Red Hot Chili Peppers", cover: .named("RHCP.1984.jpg")))
            redhotchili.discography.append(Album(artist: redhotchili, name: "Freaky Styley", cover: .named ("RHCP.Freakystyleyalbumcover.jpg")))
            redhotchili.discography.append(Album(artist: redhotchili, name: "The Uplift Mofo Party Plan", cover: .named ("RHCP.UpliftMofoCover.jpg")))
            redhotchili.discography.append(Album(artist: redhotchili, name: "Mother's Milk", cover: .named("RHCP.Mother'sMilkAlbumcover.jpg")))
            redhotchili.discography.append(Album(artist: redhotchili, name: "Blood Sugar Sex Magic", cover: .named("RHCP.BSSM.jpg")))
            channelArray.append(redhotchili)
            
            channelArray.append(Artist(name: "Boston", listeners: 6032, cover: .named( "Boston - Dont Look Back.jpg") ))
            channelArray.append(Artist(name: "Madness", listeners: 230, cover: .named("Madness - One Step Beyond.jpg")))
            channelArray.append(Artist(name: "The Specials", listeners: 67, cover: .named("Specials uk front.jpg")))
            
            return channelArray
        }
    }
}

