//
//  CreateAccountVCPageOne.swift
//  MyHobbies
//
//  Created by Wael on 3/21/19.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit
import Firebase



var UserName:String!
var UserEmail:String?
var UserBdDate:String?
var UserPNumber:String?
var UserGender:String?
var UserBio:String?
var UserUID:String?
var UserPassword:String?
var UserImage:String?
var arrSelectedData = [String]()
var UserPoint:String?
var UserCity:String?
class CreateAccountVCPageOne: UIViewController ,UITextFieldDelegate{
    
    private var datapicker: UIDatePicker?
    
    @IBOutlet weak var IMG: UIImageView!
    @IBOutlet weak var City: ACFloatingTextfield!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Date: UITextField!
    @IBOutlet weak var PhoneNumber: UITextField!
    @IBOutlet weak var Gender: UISegmentedControl!
    @IBOutlet weak var Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurEffect(img: IMG)
        Name.text = UserName
        Email.text = UserEmail
        Date.text = UserBdDate
        PhoneNumber.text = UserPNumber
        if UserGender == "Female" {
            Gender.selectedSegmentIndex = 1
            }
        else {
            Gender.selectedSegmentIndex = 0
        }
        selectBirthDay()
        
    }
    
    
    
    @objc func dateChanged(datePicker:UIDatePicker) {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy/MM/dd"
        Date.text = dateformat.string(from: datePicker.date)
        let v = dateformat.string(from: datePicker.date)
        UserBdDate = v
    }
    @objc func ViewTapped(GestureRecognizer:UITapGestureRecognizer){
        view.endEditing(true)
        return
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func selectBirthDay() {
        datapicker = UIDatePicker()
        datapicker?.datePickerMode = .date
        Date.inputView = datapicker
        datapicker?.addTarget(self, action: #selector(CreateAccountVCPageOne.dateChanged(datePicker:)), for: .valueChanged)
        let tapG = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVCPageOne.ViewTapped(GestureRecognizer:)))
        view.addGestureRecognizer(tapG)
    }
    
    
    
    func UserInfo() {
        UserName     = Name.text!
        UserEmail    = Email.text!
        UserBdDate   = Date.text!
        UserPNumber  = PhoneNumber.text!
        UserPassword = Password.text!
        UserCity     = City.text!
        if Gender.selectedSegmentIndex == 0 {
            UserGender = "Male"
        } else {
            UserGender = "Female"
        }
    }
    
    
    
    
    @IBAction func Next(_ sender: Any) {
        UserInfo()
        performSegue(withIdentifier: "CreateAccountPTwo", sender: nil)
    }
    
    
    // Limit Length for Name
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
        let currentString: NSString = Name.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
   
    
}
