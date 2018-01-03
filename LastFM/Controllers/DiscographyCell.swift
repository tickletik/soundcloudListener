//
//  DicographyTVCell.swift
//  SoundcloudListener
//
//  Created by ronny abraham on 12/31/17.
//  Copyright © 2017 ronny abraham. All rights reserved.
//

import UIKit

class DiscographyCell: UITableViewCell {

    @IBOutlet weak var imageViewLeft: UIImageView!
    @IBOutlet weak var labelLeft: UILabel!
    
    @IBOutlet weak var imageViewRight: UIImageView!
    @IBOutlet weak var labelRight: UILabel!
    
    @IBOutlet weak var firstStack: UIStackView!
    @IBOutlet weak var secondStack: UIStackView!
    
    
    let leftGestureTap = UITapGestureRecognizer()
    let rightGestureTap = UITapGestureRecognizer()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        firstStack.isUserInteractionEnabled = true
        secondStack.isUserInteractionEnabled = true
        
        
        leftGestureTap.addTarget(self, action: #selector(DiscographyCell.tappedLeft))
        rightGestureTap.addTarget(self, action: #selector(DiscographyCell.tappedRight))
        
        firstStack.addGestureRecognizer(leftGestureTap)
        secondStack.addGestureRecognizer(rightGestureTap)
    }
    
    @IBAction func tappedLeft() {
        print("tapped Left")
    }

    @IBAction func tappedRight() {
        print("tapped right")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
