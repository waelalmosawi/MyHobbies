//
//  AccountCV.swift
//  MyHobbies
//
//  Created by Wael on 3/21/19.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit
import Firebase
import CoreImage

var Hobbies = [String]()

class AccountCV: UIViewController , UITableViewDelegate , UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var ProfileIMGBLURE: UIImageView!
    @IBOutlet weak var ProfileIMG: RoundedImageView!
    @IBOutlet weak var MoreBotton: UIButton!       // more button
    @IBOutlet weak var CoverImage: UIImageView!    // Cover Image
    @IBOutlet weak var MyViewCover: UIView!        // View Cover
    @IBOutlet weak var UserBioLAb: UITextView!     // User Bio
    @IBOutlet weak var MyTableView: UITableView!   // MyTableView
    @IBOutlet weak var UserPointLAB: UILabel!      // User Point
    @IBOutlet weak var UserNameeLAB: UILabel!      // UserName
    
    
    
                      // Hobbies are selected by user
    
    var ref: DatabaseReference!                    // DataBase Refrence
    
    
   
    var Myindex = 0
    // Button For TabelView What to do
    @objc func ShowMyHobbies(_ sender: AnyObject, secondParams: AnyObject) {
        performSegue(withIdentifier: "TY", sender: nil)
    }
    
    @objc func ShowMyEvent(_ sender: AnyObject, secondParams: AnyObject) {
        performSegue(withIdentifier: "MyEvent", sender: nil)
    }
    @objc func ShowMyPost(_ sender: AnyObject, secondParams: AnyObject) {
        performSegue(withIdentifier: "Mypost", sender: nil)
    }
    // end
    
    
    // Start CollectionView Implimintation
    
        // Number Of Item in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Hobbies.count
    }
       // end
    
       // collectionView cell Implimintation
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "One", for: indexPath) as? ACPCVCO
        cell?.Mylabel.text = Hobbies[indexPath.row]
        cell?.Mylabel.layer.cornerRadius = 20
        cell?.MyPhoto.image = UIImage(named: "Photography.jpg")
        return cell!
    }
      //  end
    //End CollectionView Implimintation
    
    
    
    // Start TabelView Implimintation
         // Make TableView Header with Button & label
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let button = UIButton(type: .system)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        
        // Make View
        view.backgroundColor = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0)
        //Make Label
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.backgroundColor = UIColor.lightText
        if section == 0 {
            label.text = "MyHobbies"
        }else if section == 1 {
            label.text = "MyPost"
        }else {
            label.text = "MyEvent"
        }
        
        label.textColor = UIColor.black
        label.frame = CGRect(x: 20, y: 0, width: tableView.frame.width - 300 , height:28)
        label.layer.cornerRadius = 13
        label.layer.masksToBounds = true
        
        //Make Button
        button.backgroundColor = UIColor.lightText
        button.layer.cornerRadius = 13
        button.frame = CGRect(x: 305, y: 0, width: tableView.frame.width - 325 , height:28)
        button.setTitle("View All", for: .normal)
        if section == 0 {
           //  button.addTarget(self, action: #selector(AccountCV.ShowMyHobbies(_:secondParams:)), for: .touchUpInside)
        } else if section == 1 {
           // button.addTarget(self, action: #selector(AccountCV.ShowMyPost(_:secondParams:)), for: .touchUpInside)
        }else {
               // button.addTarget(self, action: #selector(AccountCV.ShowMyEvent(_:secondParams:)), for: .touchUpInside)
        }
        //Add label & button in view
        view.addSubview(button)
        view.addSubview(label)
        return view
    }
    //  end
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
        return 1
        }else if section == 1 {
            return 1
        }else {
            return 1
        }}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "One", for: indexPath) as? ACPTVCO
        cell?.MyCollectionView.reloadData()
        return cell!
    }
    
   

  
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MoreBotton.layer.cornerRadius = 13
        ///
        MyViewCover.layer.cornerRadius = 20
        MyViewCover.layer.shadowRadius = 20
        ////
        blurEffect(img: CoverImage)
        blurEffect(img: ProfileIMGBLURE)
        ref = Database.database().reference()
        LodUserInfo()
        LoadMessages()
        
    }
    
    func LodUserInfo(){
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("MyUser").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["Name"] as? String ?? ""
            let UserPoint = value?["UserPoint"] as? String ?? ""
            let UserCity = value?["City"] as? String ?? ""
            let Bio = value?["Bio"] as? String ?? ""
            let imagProf = value?["ImagePath"] as? String ?? ""
            self.ProfileIMG.sd_setImage(with:URL(string:imagProf))
            self.ProfileIMGBLURE.sd_setImage(with:URL(string:imagProf))
            self.UserNameeLAB.text = username
            self.UserPointLAB.text = "\(UserCity) | MyPoint \(UserPoint)"
            self.UserBioLAb.text = Bio
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
  
    
    func LoadMessages(){
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        ref.child("MySelectedHob").child(userID!).observeSingleEvent(of:.value, with: { (snapshot) in
            Hobbies.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if  let Hobbiess = snap.value as? String {
                        Hobbies.append(Hobbiess)
                        // Get user value
                    }
                    // ...
                }
                self.MyTableView.reloadData()
                
            }
            
        }
        )
    }
    
    @IBAction func Exit(_ sender: Any) {
       performSegue(withIdentifier: "Settings", sender: nil)
    
    }
    
}
