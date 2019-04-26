//
//  Tessssst.swift
//  MyHobbies
//
//  Created by Wael on 4/11/19.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit
import Firebase

class Tessssst: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var ListMessages=Array<Message>()
    var ref=DatabaseReference.init()
    @IBOutlet weak var MyTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref=Database.database().reference()
        MyTable.dataSource=self
        MyTable.delegate=self
        self.MyTable.rowHeight = UITableView.automaticDimension;
        self.MyTable.estimatedRowHeight = 250;
        LoadMessages()
    }
    
    @objc func refresh(_ sender: Any) {
        MyTable.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let onemessage = ListMessages[indexPath.row]
        if onemessage.ImagePath == "No_Image"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "waelT", for: indexPath) as! waelViewCell
            cell.setText(msg:onemessage)
            self.SetStyleCell(cell:cell)
           
            
           
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "wael", for: indexPath) as! waelViewCell
            cell.setTextWithImage(msg: onemessage)
            cell.blurEffect()
            self.SetStyleCell(cell:cell)
            return cell
        }
        
        }

    func SetStyleCell(cell:waelViewCell){
        cell.layer.cornerRadius = 15 //set corner adius here
        cell.layer.borderColor =  UIColor.gray.cgColor // set cell border color here
        cell.layer.borderWidth = 1 // set border width here
    }
    
    func LoadMessages(){
        self.ref.child("MyHob").child("B").observe(.value, with: { (snapshot) in
            self.ListMessages.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? [String: AnyObject] {
                        self.setMessage(msgId: snap.key, msgData: postDict)
                    }
                }
            }
            self.MyTable.reloadData()
        })
    }
    func setMessage(msgId: String, msgData: [String: AnyObject]) {
        var ImagePath:String!
        var Post:String!
        var UID:String!
        if let ImagePath1 = msgData["ImagePath"] as? String {
            ImagePath = ImagePath1
        }
        if let UID1 = msgData["UID"] as? String {
            UID = UID1
        }
        if let Post1 = msgData["text"] as? String {
            Post = Post1
        }
        self.ListMessages.append(Message(ImagePath: ImagePath!,Post: Post,UID: UID!))
    }
}

