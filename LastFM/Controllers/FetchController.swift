//
//  FetchArtist.swift
//  LastFM
//
//  Created by ronny abraham on 1/8/18.
//  Copyright © 2018 ronny abraham. All rights reserved.
//

import Foundation
import UIKit

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


protocol ArtistDelegate {
    func setArtists(artists: [Artist])
}


class FetchController {

    var baseURL: URL?
    var api_key: String
    var format: String
    
    
    init(api_key: String = "9c0cbfb76c4b7e2b3e4e559d8d0ff13c", format: String = "json",  base_url: String = "http://ws.audioscrobbler.com/2.0/?") {
        self.api_key = api_key
        self.format = format
        self.baseURL = URL(string: base_url)
        
    }
    
    func fetchArtists(country: CountryCodes, limit:Int = 2, delegate: ArtistDelegate, completion: @escaping (ArtistDelegate, [LastFMArtist]?) -> Void) {
        
        let query: [String: String] = [
            "method": "geo.gettopartists",
            "country": country.rawValue,
            "api_key": api_key,
            "format": format,
            "limit" : "\(limit)"
        ]
        
        let searchURL = baseURL?.withQueries(query)!
        
        let task = URLSession.shared.dataTask(with: searchURL!) { (data, response, error) in
            
            
            let jsonDecoder = JSONDecoder()
            
            if let data = data,
                let _ = try? JSONSerialization.jsonObject(with: data) {
                // print(rawJSON)
                
                if let topartists = try? jsonDecoder.decode(TopArtist.self, from:data) {
                    completion(delegate, topartists.artists)
                }
            }
        }
        
        task.resume()
    }

    func fetchImage(imageURL: URL, artist: Artist) {
        
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            
            if let e = error {
                print("Error downloading imageURL: \(e)")
            } else {
                if let res = response as? HTTPURLResponse {
                    print("dowloaded imageURL with response code \(res.statusCode)")
                    
                    if let imageData = data {
                        let _ = UIImage(data: imageData)
                        //artist.cover = image
                    }
                }
            }
        }
        
        task.resume()
    }
    
    
    func artistHandler (delegate: ArtistDelegate, fetchedArtists: [LastFMArtist]?) -> Void {
        
        if let fetchedArtists = fetchedArtists {
            
            var artists: [Artist] = []
            
            for fArtist in fetchedArtists {
                
                let url:URL = (fArtist.getLastFMImage(size: .medium)?.url)!
                let artist = Artist(name: fArtist.name, listeners: fArtist.listeners, cover: .url(url))
                artists.append(artist)
                
                fArtist.debug()
                //fetchDiscography(artist: artist, completion: discographyHandler)
            }
            
            delegate.setArtists(artists: artists)
        }
    }
    
    
}
