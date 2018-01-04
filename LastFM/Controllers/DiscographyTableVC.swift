//
//  DiscographyTableVC.swift
//  SoundcloudListener
//
//  Created by ronny abraham on 12/31/17.
//  Copyright © 2017 ronny abraham. All rights reserved.
//

import UIKit

protocol DiscographyDelegate {
    func showAlbum(album: Album)
}

class DiscographyTableVC: UITableViewController, DiscographyDelegate {
    
    func showAlbum(album: Album) {
        print("show album \(album)")
        performSegue(withIdentifier: "AlbumSegue", sender: nil)
    }
    

    var discography: [Album] = []
    var artist: Artist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        if let artist = artist {
            discography = artist.discography
        } else {
            artist = Artist.defaultData[2]
            discography = artist!.discography
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*
            there are two albums on each row
            dividing an int by 2, the return value is floored
            check if the number is odd, then add a row
        */
        
        var rows = discography.count / 2
        
        if discography.count % 2 == 1 {
            rows += 1
        }
        return rows
    }
    
    func getRow(index: Int) -> Int {
        var rows = index / 2
        
        if index % 2 == 1 {
            rows += 1
        }
        
        return rows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DiscographyCell = tableView.dequeueReusableCell(withIdentifier: "DiscographyCell", for: indexPath) as! DiscographyCell

        let rownum = indexPath.row
        
        let indexFirst = rownum * 2
        let indexSecond = indexFirst + 1
        
        cell.delegate = self
        cell.setAlbum(album: discography[indexFirst], .left)
        
        if indexSecond < discography.count {
            cell.setAlbum(album: discography[indexSecond], .right)
            
        } else {
            cell.setAlbum(album: nil, .right)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
