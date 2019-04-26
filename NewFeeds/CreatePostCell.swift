//
//  CreatePostCell.swift
//  MyHobbies
//
//  Created by Wael on 4/1/19.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit
import Firebase
class CreatePostCell: UITableViewCell {
    @IBOutlet weak var Publish: UIButton!
    @IBOutlet weak var SetImageR: UIButton!
    
    
    
    @IBOutlet weak var SelecttHobbies: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    @IBAction func Publish(_ sender: Any) {
        
    }
}
