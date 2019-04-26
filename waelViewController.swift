//
//  waelViewController.swift
//  MyHobbies
//
//  Created by Wael on 4/1/19.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit
import Firebase
class waelViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var MytableView: UITableView!
    
    
    var ref=DatabaseReference.init()
    var ListMessages = [String]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wael", for: indexPath) as! waelViewCell
        cell.Mytext.text = ListMessages[indexPath.row]
        return cell
        }
    func SetStyleCell(cell:waelViewCell){
        cell.layer.cornerRadius=5 //set corner adius here
        cell.layer.borderColor =  UIColor.lightGray.cgColor // set cell border color here
        cell.layer.borderWidth = 3 // set border width here
    }
    
    func LoadMessage(){
        ref = Database.database().reference()
        ref.child("Test").child("ii").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["Name"] as? String ?? ""
            self.ListMessages.append(username)
            self.MytableView.reloadData()
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadMessage()
        self.ref=Database.database().reference()
        MytableView.delegate = self
        MytableView.dataSource = self
        self.MytableView.rowHeight = UITableView.automaticDimension
        self.MytableView.estimatedRowHeight = 250;

        // Do any additional setup after loading the view.
    }
  

    @IBAction func AddPost(_ sender: Any) {
         MytableView.reloadData()
        performSegue(withIdentifier: "AddPost", sender: nil)
    }
    
    
    
}
