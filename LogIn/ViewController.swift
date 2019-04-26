//
//  ViewController.swift
//  MyHobbies
//
//  Created by Wael on 3/21/19.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var IMG: UIImageView!
    
    
    var userEmail:String?
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        blurEffect(img: IMG)
        Email.text = userEmail
        hideKeyboardWhenTappedAround()
    }
    
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func LogIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: Email.text!, password: Password.text!) { (user,error) in if error == nil {
            self.performSegue(withIdentifier: "Home", sender: self)
        }
        else{
            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .actionSheet)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            }
        }
            
        }
    
    @IBAction func CreateAccount(_ sender: Any) {
     performSegue(withIdentifier: "CreateAccountPOne", sender: nil)
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "Home", sender: nil)
        }
    }
}
//DISSMISS KEYBOARD
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
   
}



extension UIViewController {
    func blurEffect(img:UIImageView) {
    let darkBlur = UIBlurEffect(style: .regular)
    let blurView = UIVisualEffectView(effect: darkBlur)
    blurView.frame = img.bounds
    img.addSubview(blurView)
}
}
