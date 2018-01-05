import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct LastFMImage: Codable, CustomStringConvertible {
    
    var description: String {
        get {
            return "ArtistImage(size: \(size), url: \(url))"
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



/*
let baseURL = URL(string: "http://ws.audioscrobbler.com/2.0/?")
let searchURL = baseURL?.withQueries(query)!
print(searchURL)
*/

fetchArtists(country: .usa) { (artistsInfo) in
    
    if let artists = artistsInfo {
        for artist in artists {
            
            // artist.debug()
            fetchDiscography(artist: artist) { (artist, discographyInfo) in
                if let discography = discographyInfo {
                    print(artist.name)
                    for album in discography {
                        album.debug("--")
                    }
                }
            }
        }
    }
}


