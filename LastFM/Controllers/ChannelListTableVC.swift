//
//  BandList.swift
//  SoundcloudListener
//
//  Created by ronny abraham on 12/31/17.
//  Copyright © 2017 ronny abraham. All rights reserved.
//

import UIKit

class ChannelListTableVC: UITableViewController {

    var artists: [Artist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artists = Artist.defaultData
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath)

        let channel = artists[indexPath.row]
        
        cell.imageView?.image = UIImage(named: channel.coverURL)
        
        
        cell.textLabel?.text = channel.name
        cell.detailTextLabel?.text = "(\(channel.listeners) listeners)"

        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let discography = segue.destination as? DiscographyTableVC
    }

}
