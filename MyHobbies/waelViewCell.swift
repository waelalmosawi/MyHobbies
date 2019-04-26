//
//  waelViewCell.swift
//  MyHobbies
//
//  Created by Wael on 4/1/19.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit
import Firebase
class waelViewCell: UITableViewCell {
    @IBOutlet weak var ProfileIMG: RoundedImageView!
    @IBOutlet weak var Myimage: UIImageView!
    @IBOutlet weak var MyTwIMG: UIImageView!
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var NameLabelTwo: UILabel!
    @IBOutlet weak var PostText: UITextView!
   
    func setText(msg:Message){
        
        let ref = Database.database().reference()
        let userID = msg.UID
        ref.child("MyUser").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["Name"] as? String ?? ""
            self.NameLabel.text = username
            let UserPhoto = value?["ImagePath"] as? String ?? ""
            let IMGG = self.ProfileIMG
            IMGG?.sd_setImage(with: URL(string: UserPhoto))
            
            
        }
        )
        
        PostText.text = msg.Post
        PostText.layer.cornerRadius = 25
        //self.iv_Image_post.layer.cornerRadius = 25;
        // self.iv_Image_post.layer.masksToBounds = true;
    }
    func setTextWithImage(msg:Message){
        let ref = Database.database().reference()
        let userID = msg.UID
        ref.child("MyUser").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["Name"] as? String ?? ""
            self.NameLabel.text = username
            let UserPhoto = value?["ImagePath"] as? String ?? ""
            let IMGG = self.ProfileIMG
            IMGG?.sd_setImage(with: URL(string: UserPhoto))
            
        }
        )
    
        SetImage(MyPath: msg.ImagePath!)
        NameLabelTwo.text = msg.UID
        PostText.text = msg.Post
        PostText.layer.cornerRadius = 25
        //self.iv_Image_post.layer.cornerRadius = 25;
        // self.iv_Image_post.layer.masksToBounds = true;
        }
    
    func SetImage(MyPath:String){
        let imagemmm = Myimage
        let imagemt = MyTwIMG
        imagemmm?.sd_setImage(with: URL(string: MyPath))
        imagemt?.sd_setImage(with: URL(string: MyPath))
        
    }
    
    
    
    
    func blurEffect() {
        let darkBlur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = Myimage.bounds
        Myimage.addSubview(blurView)
    }
    
}
