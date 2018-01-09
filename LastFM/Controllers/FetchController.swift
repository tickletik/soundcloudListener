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
    
    func fetchArtists(country: CountryCodes, limit:Int = 2, delegate: ArtistDelegate, completion: @escaping (ArtistDelegate, [Artist]?) -> Void) {
        
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
    
    func fetchDiscography(artist: Artist, limit: Int = 2, completion: @escaping (Artist, [LastFMDiscography]?) -> Void) {
        
        let query: [String:String] = [
            "method": "artist.gettopalbums",
            "artist": artist.name,
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
                
                if let lastfmResponse = try? jsonDecoder.decode(TopAlbums.self, from:data) {
                    completion(artist, lastfmResponse.albums)
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
    
    
    func artistHandler (delegate: ArtistDelegate, fetchedArtists: [Artist]?) -> Void {
        
        if let fetchedArtists = fetchedArtists {
            
            var artists: [Artist] = []
            
            for artist in fetchedArtists {
                
                //let url:URL = (fArtist.getLastFMImage(size: .medium)?.url)!
                //let artist = Artist(name: fArtist.name, listeners: fArtist.listeners, cover: .url(url))
                artists.append(artist)
                
                print("artist: \(artist)")
                fetchDiscography(artist: artist, completion: discographyHandler)
            }
            
            delegate.setArtists(artists: artists)
        }
    }
    
    func discographyHandler (artist: Artist, discographyInfo : [LastFMDiscography]?) -> Void {
        if let discography = discographyInfo {
            
            print("artist: \(artist.name)")
            for album in discography {
                
                print("discography: \(album)")
                /*
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
                */
            }
        }
    }
    
}
