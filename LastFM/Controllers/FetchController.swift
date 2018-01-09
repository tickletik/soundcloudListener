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
                
                if let lastfmResponse = try? jsonDecoder.decode(TopAlbums.self, from:data) {
                    completion(artist, lastfmResponse.albums)
                }
            }
        }
        
        task.resume()
    }

    func fetchAlbum(artist: Artist, limit: Int = 2, discography: LastFMBase, completion: @escaping (Artist, LastFMAlbum?) -> Void) {
        
        let query: [String:String] = [
            "method": "album.getinfo",
            "artist": artist.name,
            "album" : discography.name,
            "api_key": api_key,
            "format": format,
            "limit" : "\(limit)"
        ]
        
        let searchURL = baseURL?.withQueries(query)!
        
        let task = URLSession.shared.dataTask(with: searchURL!) { (data, response, error) in
            
            let jsonDecoder = JSONDecoder()
            
            if let data = data,
                let _ = try? JSONSerialization.jsonObject(with: data) {
                
                if let lastfmResponse = try? jsonDecoder.decode([String:LastFMAlbum].self, from:data) {
                    completion(artist, lastfmResponse["album"])
                }
            }
        }
        task.resume()
    }
    
    func artistHandler (delegate: ArtistDelegate, fetchedArtists: [Artist]?) -> Void {
        
        if let fetchedArtists = fetchedArtists {
            
            var artists: [Artist] = []
            
            for artist in fetchedArtists {
                
                artists.append(artist)
                fetchDiscography(artist: artist, completion: discographyHandler)
            }
            
            delegate.setArtists(artists: artists)
        }
    }
    
    func discographyHandler (artist: Artist, discographyInfo : [LastFMDiscography]?) -> Void {
        if let discography = discographyInfo {
            
            for fmAlbum in discography {
                fetchAlbum(artist: artist, discography: fmAlbum) { (artist, fmAlbum) in
                    
                    if let fmAlbum = fmAlbum {

                        let urlcover = fmAlbum.getLastFMImage(size: .mega)!.url
                        
                        let album = Album(artist: artist, name: fmAlbum.name, year: "1999", cover: .url(urlcover))
                        
                        artist.discography.append(album)
                        
                        for fmTrack in fmAlbum.tracks {
                        
                            let track = Track(album: album, number: fmTrack.number, name: fmTrack.name, time: Double(fmTrack.seconds))
                            album.tracks.append(track)
                            print("-- \(fmTrack)")
                        }
                    }
                }
                
            }
        }
    }
    
}
