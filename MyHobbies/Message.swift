//
//  Message.swift
//  ChatApp
//
//  Created by hussien alrubaye on 1/27/17.
//  Copyright © 2017 hussien alrubaye. All rights reserved.
//

import UIKit

class Message  {
    var ImagePath:String?
    var Post:String?
    var UID:String?
    init(ImagePath:String,Post:String?,UID:String?) {
        self.ImagePath = ImagePath
        self.Post = Post
        self.UID = UID
    }
}
