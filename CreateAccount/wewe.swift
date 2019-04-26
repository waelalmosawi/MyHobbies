//
//  wewe.swift
//  MyHobbies
//
//  Created by Wael on 3/22/19.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit

class wewe: UICollectionViewCell {

    @IBOutlet weak var Mylab: UILabel!
    @IBOutlet weak var View: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10 //customize yourself
        self.layer.masksToBounds = true
    }
    
    
    
    
}
