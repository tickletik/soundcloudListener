//
//  BandList.swift
//  SoundcloudListener
//
//  Created by ronny abraham on 12/31/17.
//  Copyright © 2017 ronny abraham. All rights reserved.
//

import UIKit


class ChannelListTableVC: UITableViewController, ArtistDelegate {
    
    var artists: [Artist] = []
    
    var tableRows: [(Artist, UIImage)] = []
    
    var selectedArtist: Artist?
    
    func setArtists(artists: [Artist]) {
        self.artists = artists
        
        for artist in artists {
            tableRows.append((artist, UIImage(named: artist.cover.value() as! String )! ))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //let fetch = FetchController()
        //fetch.fetchArtists(country: .usa, limit: 2, delegate: self, completion: fetch.artistHandler)
        
        
        setArtists(artists: Artist.defaultData)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRows.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath)

        let (artist, image) = tableRows[indexPath.row]
        
        cell.imageView?.image = image
        cell.textLabel?.text = artist.name
        cell.detailTextLabel?.text = "(\(artist.listeners) listeners)"

        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "DiscographySegue" {
            let discographyTableVC = segue.destination as? DiscographyTableVC
            
            let indexPath = tableView.indexPathForSelectedRow!
            let artist = artists[indexPath.row]
            
            discographyTableVC?.artist = artist
        }
    }

}
