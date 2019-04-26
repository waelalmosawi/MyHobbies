//
//  TableViewController.swift
//  MyHobbies
//
//  Created by Wael on 3/30/19.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit
import Firebase
class TableViewController: UITableViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    
    //TableView Implimentations
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if indexPath.row == 4 {
            cell.textLabel?.text = "LogOut"
        }else {
            cell.textLabel?.text = "wael"
        }
       

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
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
        else{
            print(indexPath.row)
            let view = UIView()
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.backgroundColor = .yellow
            view.addSubview(label)
            
        }
        
    }
    

}
