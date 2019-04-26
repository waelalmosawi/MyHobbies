//
//  EditPage.swift
//  MyHobbies
//
//  Created by Wael on 4/18/19.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit
import Firebase
class EditPage: UIViewController {

    let imagePicker = UIImagePickerController()
    var ref = DatabaseReference.init()
    
    
    @IBOutlet weak var SaveCancleButtone: UIButton!
    @IBOutlet weak var ProfileIMG: RoundedImageView!
    @IBOutlet weak var ViewCover: UIView!
    @IBOutlet weak var CoverIMG: UIImageView!
    
    
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var UserCity: UITextField!
    @IBOutlet weak var UserPhoneNumber: UITextField!
    @IBOutlet weak var UserBio: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        LodUserInfo()
        
        
        hideKeyboardWhenTappedAround()
        
        
        
        SaveCancleButtone.backgroundColor = .clear
        SaveCancleButtone.layer.cornerRadius = 10
        SaveCancleButtone.layer.borderWidth = 1
        SaveCancleButtone.layer.borderColor = UIColor.black.cgColor
        
        
        
        ViewCover.layer.cornerRadius = 25
        
        
        
        
        blurEffect(img: CoverIMG)
    }
    
    
    func LodUserInfo(){
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("MyUser").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["Name"] as? String ?? ""
            self.UserName.text = username
            let HP = value?["PhoneNumber"] as? String ?? ""
            self.UserPhoneNumber.text = HP
            let City = value?["City"] as? String ?? ""
            self.UserCity.text = City
            let bio = value?["Bio"] as? String ?? ""
            self.UserBio.text = bio
            let IMG = value?["ImagePath"] as? String ?? ""
            self.ProfileIMG.sd_setImage(with: URL(string: IMG))
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func saveFIRData(){
            self.uploadImage(self.ProfileIMG.image!){ url in
                self.saveImage(profileURL: url!) {
                    success in
                    if success != nil {
                        print("yes ")
                    }
                }
            }
        }

    
    @IBAction func SaveORCancle(_ sender: Any) {
        saveFIRData()
        let DB = Database.database().reference()
        let C = Auth.auth().currentUser?.uid
        let NewName = self.UserName.text
        DB.child("MyUser").child(C!).child("Name").setValue(NewName)
    }
    
    
    
    @IBAction func ChangePhoto(_ sender: Any) {
        self.systemImagePicker()
    }
    
    
    
    
}
extension EditPage: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    
    
    func systemImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            imagePicker.isEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        ProfileIMG.image = image
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // change image size
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
//var wael = ""
extension EditPage {
    func uploadImage(_ image:UIImage,completion: @escaping (_ url: URL?) -> ()){
        let storegRRef = Storage.storage().reference(forURL: "gs://myhobbies-e447d.appspot.com/")
        let resizedImage = resizeImage(image: (ProfileIMG.image)!, targetSize: CGSize.init(width: 414, height: 305))
        let imageData = resizedImage.pngData()
        let metaData = StorageMetadata()
        let dateformat=DateFormatter()
        dateformat.dateFormat="MM_DD_yy_h_mm_a"
        let imageName=dateformat.string(from: NSDate() as Date )
        metaData.contentType = "image/png"
        let ImagePah="images/\(imageName)"
        wael = ImagePah
        let storegRef = storegRRef.child(ImagePah)
        storegRef.putData(imageData!, metadata: metaData, completion: {(metaData , error) in
            if error == nil {
                print("success")
                storegRef.downloadURL(completion:{ (url,error) in
                    completion(url)
                } )
            }else{
                print("error in save image")
                completion(nil)
            }
            
        })
    }
    
    
    func saveImage(profileURL:URL,completion: @escaping ((_ url: URL?) -> ())){
        let ref = Database.database().reference()
        let currentUU = Auth.auth().currentUser?.uid
        ref.child("MyUser").child(currentUU!).child("ImagePath").setValue(profileURL.absoluteString)
    }
}


