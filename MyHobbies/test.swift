//
//  ViewController.swift
//  ChatApp
//
//  Created by hussien alrubaye on 1/27/17.
//  Copyright © 2017 hussien alrubaye. All rights reserved.
//

import UIKit
import Firebase

class testttttt: UIViewController,
UITableViewDelegate,UITableViewDataSource
,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    let UserName = "Hussein" // TODO: will update soon
    
    
    
    var ref=DatabaseReference.init()
    var ListMessages=Array<Message>()
    var imagePicker:UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // database  instance
        self.ref=Database.database().reference()
        
        tableView.dataSource=self
        tableView.delegate=self
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 250;
        LoadMessages()
        //
        imagePicker=UIImagePickerController()
        imagePicker.delegate=self
    }

   
 

   
    
    // tbale ivee implement
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListMessages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneMessage=ListMessages[indexPath.row]
        
        if oneMessage.ImagePath == "no_image" {
          
        let cell:TableViewCell=tableView.dequeueReusableCell(withIdentifier: "cellText", for: indexPath) as! TableViewCell
        cell.setText(msg: oneMessage)
            self.SetStyleCell(cell:cell)
        return cell
        }
        else{
            //cellTextWithImage
            let cell:TableViewCell=tableView.dequeueReusableCell(withIdentifier: "cellTextWithImage", for: indexPath) as! TableViewCell
            cell.setTextWithImage (msg:  oneMessage)
            self.SetStyleCell(cell:cell)
            return cell
        }
    }
    // set style for the cell
    func SetStyleCell(cell:TableViewCell){
     
        cell.layer.cornerRadius=5 //set corner adius here
        cell.layer.borderColor =  UIColor.lightGray.cgColor // set cell border color here
        cell.layer.borderWidth = 3 // set border width here
    }
    
    func LoadMessages(){
        self.ref.child("messages").queryOrdered(byChild: "postDate").observe(.value, with: { (snapshot) in
            
            self.ListMessages.removeAll()
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? [String: AnyObject] {
                        //  let msgData = postDict as?  [String: AnyObject]
                        
                        self.setMessage(msgId: snap.key, msgData: postDict)
                        
                    }
                }
            }
            self.tableView.reloadData()
            // self.scrollToBottom()
            
        })
        

    }
    func scrollToBottom(){
        DispatchQueue.global(qos: .background).async {
            let indexPath = IndexPath(row: self.ListMessages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func setMessage(msgId: String, msgData: [String: AnyObject]) {
        var text:String!
        var UserName:String!
        var PostDate:String!
        var ImagePath:String!
        if let UserName1 = msgData["UserName"] as? String {
            UserName = UserName1
        }
       
        
        if let postDate1 = msgData["postDate"] as? String {
            PostDate = postDate1
            
        }
        else{
            PostDate="no_date"}
        
        if let text1  = msgData["text"] as? String {
            text  = text1
        }
        else{
            text=" "}
        if let ImagePath1 = msgData["ImagePath"] as? String {
            ImagePath = ImagePath1
        }
        else{
            ImagePath = "no_image"}
        
        self.ListMessages.append(Message(text: text!, UserName: UserName!, PostDate: PostDate!, ImagePath: ImagePath!))
    }
}


