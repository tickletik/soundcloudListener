//
//  AlbumViewController.swift
//  LastFM
//
//  Created by ronny abraham on 1/3/18.
//  Copyright © 2018 ronny abraham. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var album = Artist.defaultData[0].discography[0]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath)
        
        cell.textLabel?.text = album.tracks[indexPath.row].name
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
