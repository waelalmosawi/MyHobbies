//
//  ACPTVCO.swift
//  MyHobbies
//
//  Created by Wael on 3/27/19.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit

class ACPTVCO: UITableViewCell {
    
    
    var cellWidth:CGFloat = 0
    var cellHeight:CGFloat = 0
    var spacing:CGFloat = 12
    var numberOfColumn:CGFloat = 2
    
    @IBOutlet weak var MyCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func x(){
        MyCollectionView.contentInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        if let flowLayout = MyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            cellWidth = (MyCollectionView.frame.width  - (numberOfColumn + 1)*spacing)/numberOfColumn
            cellHeight = 100 //yourCellHeight
            flowLayout.minimumLineSpacing = spacing
            flowLayout.minimumInteritemSpacing = spacing
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  

}
