//
//  SettingsPage.swift
//  MyHobbies
//
//  Created by Wael on 4/18/19.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit
import Firebase
class SettingsPage: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    var UName:String!
    var MyOptions = [String]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = MyOptions[indexPath.row]
        cell.textLabel?.textColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let x = indexPath.row
        if x == 1 {
            do {
                try Auth.auth().signOut()
            }
            catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initial = storyboard.instantiateInitialViewController()
            UIApplication.shared.keyWindow?.rootViewController = initial
        }
        else if x == 0 {
            performSegue(withIdentifier: "Edit", sender: nil)
        }
    }

    @IBOutlet weak var MyTableView: UITableView!
    
    
    
    
    @IBOutlet weak var CoverIMG: UIImageView!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LodUserInfo()
        blurEffect(img: CoverIMG)
    }

    
    
    func LodUserInfo(){
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("MyUser").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["Name"] as? String ?? ""
            self.UName = username
            self.MyOptions = ["EditProfile","Log Out of \(self.UName ?? "")"]
            self.MyTableView.reloadData()
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}
