//
//  MyTableViewController.swift
//  
//
//  Created by Wael on 4/11/19.
//

import UIKit
import Firebase
class MyTableViewController: UITableViewController {
    
    
    var rrefreshControl   = UIRefreshControl()
    
    var ListMessages=Array<Message>()
    var ref=DatabaseReference.init()
    @IBOutlet var MyTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadMessages()
        self.MyTable.reloadData()
        self.ref=Database.database().reference()
        // Refresh control add in tableview.
        rrefreshControl.attributedTitle = NSAttributedString(string: "Loding..")
        rrefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.MyTable.addSubview(rrefreshControl)
        self.MyTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")


      
    }
    
    @objc func refresh(_ sender: Any) {
        MyTable.reloadData()
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListMessages.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneMessage=ListMessages[indexPath.row]
        if oneMessage.ImagePath == "no_image" {
            
            let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! waelViewCell
            cell.setText(msg: oneMessage)
            self.SetStyleCell(cell:cell)
            return cell
        }
        else{
            //cellTextWithImage
            let cell=tableView.dequeueReusableCell(withIdentifier: "cellT", for: indexPath) as! waelViewCell
            cell.setTextWithImage (msg:  oneMessage)
            self.SetStyleCell(cell:cell)
            return cell
        }
    }
    // set style for the cell
    func SetStyleCell(cell:waelViewCell){
        cell.layer.cornerRadius=5 //set corner adius here
        cell.layer.borderColor =  UIColor.lightGray.cgColor // set cell border color here
        cell.layer.borderWidth = 3 // set border width here
    }
    //CorrectionTableView SYNC
    func scrollToBottom(){
        DispatchQueue.global(qos: .background).async {
            let indexPath = IndexPath(row: self.ListMessages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    func LoadMessages(){
        self.ref.child("Posts").child("drawing").queryOrdered(byChild: "date").observe(.value, with: { (snapshot) in
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
    
    func setMessage(msgId: String, msgData: [String: AnyObject]) {
        var text:String!
        var UserName:String!
        var ImagePath:String!
        if let UserName1 = msgData["userName"] as? String {
            UserName = UserName1
        }
        
        if let text1  = msgData["text"] as? String {
            text  = text1
        }
        else{
            text=" "}
        if let ImagePath1 = msgData["imagePath"] as? String {
            ImagePath = ImagePath1
        }
        else{
            ImagePath = "no_image"}
        
        self.ListMessages.append(Message(text: text!, UserName: UserName!,ImagePath: ImagePath!))
    }
 
  
}
