//
//  UserInfo.swift
//  MyHobbies
//
//  Created by Wael on 3/21/19.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit

class UserIInfo:NSObject{
    var Name:String?
    var Email:String?
    var BdDate:String?
    var PNumber:String?
    var Gender:String?
    var Bio:String?
    var UID:String?
    
    
    init(Name:String,Email:String,BdDate:String,PNumber:String,Gender:String,Bio:String,UID:String) {
        self.Name = Name
        self.Email = Email
        self.BdDate = BdDate
        self.Gender = Gender
        self.Bio = Bio
        self.UID = UID
    }
    
}
