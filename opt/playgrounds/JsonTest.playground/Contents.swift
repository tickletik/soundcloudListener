import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct LastFMImage: Codable, CustomStringConvertible {
    
    var description: String {
        get {
            return "LastFMImage(size: \(size), url: \(url))"
        }
    }
    
    var size: String
    var url: URL
    
    enum Sizes: String {
        case small
        case medium
        case large
        case extralarge
        case mega
    }
    
    enum CodingKeys: String, CodingKey {
        case url = "#text"
        case size
    }
}

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

class LastFMArtist: LastFMBase, CustomStringConvertible {
    var description: String {
        get {
            return "LastFMArtist(name: \(name), listeners: \(listeners), images: \(images))"
        }
    }
    
    var listeners: Int
    
    enum CodingKeys: String, CodingKey {
        case listeners
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let listeners = try values.decode(String.self, forKey: .listeners)
        self.listeners = Int(listeners)!
        
        try super.init(from: decoder)
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

class LastFMAlbum: LastFMBase, CustomStringConvertible {
    var description: String {
        get {
            return "LastFMAlbum()"
        }
    }
    
    let tracks: [LastFMTrack]
    
    enum CodingKeys: String, CodingKey {
        case tracks
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let tracktest = try values.decode([String: [LastFMTrack]].self, forKey: .tracks)
        tracks = tracktest["track"]!
        
        try super.init(from: decoder)
    }
   
}

struct TopArtist: Codable, CustomStringConvertible {
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
    
    let artists: [LastFMArtist]
    
    enum CodingKeys: String, CodingKey {
        case artists = "artist"
    }
    
    enum ContainerKeys: String, CodingKey {
        case container = "topartists"
    }
    
    init(from decoder: Decoder) throws {
        let topcontainer = try decoder.container(keyedBy: ContainerKeys.self)
        
        let values = try topcontainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .container)
        artists = try values.decode([LastFMArtist].self, forKey: .artists)
    }
}

class LastFMDiscography: LastFMBase, CustomStringConvertible {
    var description: String {
        get {
            return "LastFMDiscography(name: \(name), images: \(images))"
        }
    }
}


struct TopAlbums: Codable, CustomStringConvertible {
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

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        /// returns a properly formed url with all the additions
        /// query requests on it
        
        /// the URL is meant to be used as an REST or POST request
        
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.flatMap { URLQueryItem(name: $0.0, value: $0.1)  }
        
        return components?.url
    }
}

enum CountryCodes: String {
    case uk = "united kingdom"
    case sn = "spain"
    case il = "israel"
    case usa = "united states"
}

func fetchArtists(country: CountryCodes, completion: @escaping ([LastFMArtist]?) -> Void) {
    
    let query: [String: String] = [
        "method": "geo.gettopartists",
        "country": country.rawValue,
        "api_key": "9c0cbfb76c4b7e2b3e4e559d8d0ff13c",
        "format": "json",
        "limit" : "2"
    ]
    let baseURL = URL(string: "http://ws.audioscrobbler.com/2.0/?")
    let searchURL = baseURL?.withQueries(query)!

    let task = URLSession.shared.dataTask(with: searchURL!) { (data, response, error) in
        
        
        let jsonDecoder = JSONDecoder()
        
        if let data = data,
            let _ = try? JSONSerialization.jsonObject(with: data) {
            // print(rawJSON)
            
            if let topartists = try? jsonDecoder.decode(TopArtist.self, from:data) {
                completion(topartists.artists)
            }
        }
    }
    
    task.resume()
}

func fetchDiscography(artist: LastFMArtist, completion: @escaping (LastFMArtist, [LastFMDiscography]?) -> Void) {
    
    let query: [String:String] = [
        "method": "artist.gettopalbums",
        "artist": artist.name,
        "api_key": "9c0cbfb76c4b7e2b3e4e559d8d0ff13c",
        "format": "json",
        "limit" : "2"
    ]
    
    let baseURL = URL(string: "http://ws.audioscrobbler.com/2.0/?")
    let searchURL = baseURL?.withQueries(query)!
    
    let task = URLSession.shared.dataTask(with: searchURL!) { (data, response, error) in
        
      
        let jsonDecoder = JSONDecoder()
        
        if let data = data,
            let _ = try? JSONSerialization.jsonObject(with: data) {
            // print(rawJSON)
            
            if let lastfmResponse = try? jsonDecoder.decode(TopAlbums.self, from:data) {
                completion(artist, lastfmResponse.albums)
            }
        }
    }
    
    task.resume()
}

func fetchAlbum(artist: LastFMArtist, discography: LastFMBase, completion: @escaping (LastFMArtist, LastFMAlbum?) -> Void) {
    
    let query: [String:String] = [
        "method": "album.getinfo",
        "artist": artist.name,
        "album" : discography.name,
        "api_key": "9c0cbfb76c4b7e2b3e4e559d8d0ff13c",
        "format": "json",
        "limit" : "2"
    ]
    
    let baseURL = URL(string: "http://ws.audioscrobbler.com/2.0/?")
    let searchURL = baseURL?.withQueries(query)!
    print("searchURL: \(searchURL)")
    
    let task = URLSession.shared.dataTask(with: searchURL!) { (data, response, error) in
        
        
        let jsonDecoder = JSONDecoder()
        
        if let data = data,
            let _ = try? JSONSerialization.jsonObject(with: data) {
            
            // print(rawJSON)
            //print("got album data for \(artist.name) \(discography.name)")
            
            
            if let lastfmResponse = try? jsonDecoder.decode([String:LastFMAlbum].self, from:data) {
                completion(artist, lastfmResponse["album"])
            }
            
        }
    }
    
    task.resume()
}
/*
let query: [String:String] = [
    "method": "album.getinfo",
    "artist": artist.name,
    "album" : album.name
    "api_key": "9c0cbfb76c4b7e2b3e4e559d8d0ff13c",
    "format": "json",
    "limit" : "2"
]

let baseURL = URL(string: "http://ws.audioscrobbler.com/2.0/?")
let searchURL = baseURL?.withQueries(query)!
print(searchURL)
*/

func discographyHandler (artist: LastFMArtist, discographyInfo : [LastFMDiscography]?) -> Void {
    if let discography = discographyInfo {
        
        print("artist: \(artist.name)")
        for album in discography {
            fetchAlbum(artist: artist, discography: album) { (artist, album) in
                
                if let album = album{
                    print("\n-artist: \(artist.name)")
                    print("-album: \(album.name)"  )
                    print("-cover: \(album.getLastFMImage(size: .medium)!.url)")
                    
                    for track in album.tracks {
                        print("-- \(track)")
                    }
                    //print(album.tracks)
                }
                
            }
        }
    }
}

func artistHandler (artistsInfo: [LastFMArtist]?) -> Void {
    print("in artist handler")
    if let artists = artistsInfo {
        for artist in artists {
            
            // artist.debug()
            fetchDiscography(artist: artist, completion: discographyHandler)
            
        }
    }
}

fetchArtists(country: .usa, completion: artistHandler)


