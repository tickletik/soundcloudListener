//
//  BandList.swift
//  SoundcloudListener
//
//  Created by ronny abraham on 12/31/17.
//  Copyright © 2017 ronny abraham. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}

class ChannelListTableVC: UITableViewController, ArtistDelegate {
    
    var tableRows: [(Artist, UIImage)] = []
    var selectedArtist: Artist?
    
    func setArtists(artists: [Artist]) {
        
        var image:UIImage
        
        for artist in artists {
            
            switch artist.cover {
            case .named(let named):
                image = UIImage(named: named)!
            case .url(let url):
                image = UIImage(url: url)!
            }
            tableRows.append((artist, image ))
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetch = FetchController()
        fetch.fetchArtists(country: .usa, limit: 2, delegate: self, completion: fetch.artistHandler)
        
        //setArtists(artists: Artist.defaultData)
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
            let (artist, _) = tableRows[indexPath.row]
            
            discographyTableVC?.artist = artist
        }
    }

}
