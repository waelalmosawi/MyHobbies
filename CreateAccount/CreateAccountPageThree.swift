//
//  CreateAccountPageThree.swift
//  MyHobbies
//
//  Created by Wael on 3/22/19.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit
import Firebase
@IBDesignable
class CreateAccountPageThree: UIViewController,UITextViewDelegate{
    let imagePicker = UIImagePickerController()
  
    
    @IBOutlet weak var IMG: UIImageView!
    @IBOutlet weak var BioLabel: UILabel!
    @IBOutlet weak var BioText: UITextView!
    @IBOutlet weak var ImageProfule: UIImageView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserPoint = "10"
        blurEffect(img: IMG)
        BioText.layer.cornerRadius = 20
        BioLabel.layer.cornerRadius = BioLabel.frame.width/2
        BioText.textContainer.maximumNumberOfLines = 2
        BioText.textContainer.lineBreakMode = .byWordWrapping
        self.hideKeyboardWhenTappedAround()
    }
    
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (BioText.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        BioLabel.text = String(150 - numberOfChars)
        return numberOfChars < 150    // 150 Limit Value
    }
    
    
    
    @IBAction func ChoseImage(_ sender: Any) {
         self.systemImagePicker()
    }
    
    func UserInfo(){
        UserBio = BioText.text
    }
    
    
    
    func saveFIRData(){
        UserInfo()
        self.uploadImage(self.ImageProfule.image!){ url in
            self.savePost(userpoint: UserPoint!, bio: self.BioText.text!, gen: UserGender!, email: UserEmail!, phoneNumber: UserPNumber!, Citty: UserCity!, Datte:UserBdDate!, name:UserName,profileURL:url!) {
                success in
                if success != nil {
                    print("yes ")
                }
            }
        }
    }
    
    //Send info to Database
    @IBAction func Next(_ sender: Any) {
       saveFIRData()
    }
    
    
}

extension CreateAccountPageThree: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
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
        ImageProfule.image = image
        
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

extension CreateAccountPageThree {
   
    func uploadImage(_ image:UIImage,completion: @escaping (_ url: URL?) -> ()){
        var wael = ""
        let storegRRef = Storage.storage().reference(forURL: "gs://myhobbies-e447d.appspot.com/")
        let resizedImage = resizeImage(image: (ImageProfule.image)!, targetSize: CGSize.init(width: 414, height: 305))
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
    func savePost(userpoint:String,bio:String,gen:String,email:String,phoneNumber:String,Citty:String,Datte:String,name:String,profileURL:URL,completion: @escaping ((_ url: URL?) -> ())){
        Auth.auth().createUser(withEmail: UserEmail!, password: UserPassword!){ (user, error) in if error == nil {
            let DB = Database.database().reference()
            let CurrentUsser = Auth.auth().currentUser?.uid
            let USERIN = ["Name"       :name ,
                          "ImagePath"  :profileURL.absoluteString,
                          "Date" :Datte,
                          "City" : Citty,
                          "PhoneNumber":phoneNumber,
                          "Email":email,
                          "Gender":gen,
                          "Bio":bio,
                          "UID":CurrentUsser as Any,
                          "UserPoint":userpoint
            ] as [String:Any]
            DB.child("MyUser").child(CurrentUsser!).setValue(USERIN)
            DB.child("MySelectedHob").child(CurrentUsser!).setValue(arrSelectedData)
            self.performSegue(withIdentifier: "ToMainPage", sender: nil)
            
        }
        else{
            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
