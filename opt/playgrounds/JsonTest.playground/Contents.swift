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

struct Artist: Codable, CustomStringConvertible {
    var description: String {
        get {
            return "Artist(name: \(name), listeners: \(listeners), images: \(images))"
        }
    }
    
    let name: String
    let listeners: Int
    let images: [LastFMImage]
    
    enum CodingKeys: String, CodingKey {
        case name
        case listeners
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
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        
        let listeners = try values.decode(String.self, forKey: .listeners)
        self.listeners = Int(listeners)!
        
        self.images = try values.decode([LastFMImage].self, forKey: .images)
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
    
    let artists: [Artist]
    
    enum CodingKeys: String, CodingKey {
        case artists = "artist"
    }
    
    enum TopKeys: String, CodingKey {
        case topartists
    }
    
    init(from decoder: Decoder) throws {
        let topcontainer = try decoder.container(keyedBy: TopKeys.self)
        
        let values = try topcontainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .topartists)
        artists = try values.decode([Artist].self, forKey: .artists)
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

func fetchArtists(matching query: [String: String], completion: @escaping ([Artist]?) -> Void) {
    
    let baseURL = URL(string: "http://ws.audioscrobbler.com/2.0/?")

    let searchURL = baseURL?.withQueries(query)!

    let task = URLSession.shared.dataTask(with: searchURL!) { (data, response, error) in
        
        if let response = response {
            print("\n-------beg response-------\n")
            print(response)
            print("\n-------end response-------\n")
        }
        
        if let error = error {
            print("\n---------beg error----------\n")
            print(error)
            print("\n---------end error----------\n")
        }
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


let queryArtists: [String: String] = [
    "method": "geo.gettopartists",
    "country": "united kingdom",
    "api_key": "9c0cbfb76c4b7e2b3e4e559d8d0ff13c",
    "format": "json",
    "limit" : "2"
]


/*
let query: [String:String] = [
    "method": "artist.gettopalbums",
    "artist": "cher",
    "api_key": "9c0cbfb76c4b7e2b3e4e559d8d0ff13c",
    "format": "json",
    "limit" : "2"
]

let baseURL = URL(string: "http://ws.audioscrobbler.com/2.0/?")

let searchURL = baseURL?.withQueries(query)!
print(searchURL)
*/

fetchArtists(matching: queryArtists) { (fetchedInfo) in
    if let artists = fetchedInfo {
        for artist in artists {
            print(artist.name)
            print(artist.listeners)
            
            if let url = artist.getLastFMImage(size: .small)?.url {
                print(url)
            }
            print()
        }
    }
}


