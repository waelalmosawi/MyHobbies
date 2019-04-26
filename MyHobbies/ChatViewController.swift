//
//  ChatViewController.swift
//  MyHobbies
//
//  Created by Wael on 4/2/19.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController{
  
    
    
    
    
    @IBOutlet weak var MYYYImG: UIImageView!
    
    
    
    @IBAction func RELOADDDD(_ sender: Any) {
        
        ref = Database.database().reference()
        
        ref.child("Test").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            //let value = snapshot.value as? NSDictionary
            
            
            //let PIC = value?["profilPicture"] as? String ?? ""
            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/myhobbies-e447d.appspot.com/o/images%2F04_94_19_2_42_PM.jpg?alt=media&token=03ea8516-3d77-4f4c-a782-e02692d14853")
            do {
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)
                self.MYYYImG.image = image
            }catch let err {
                print("Error : \(err.localizedDescription)")
            }
            
        }
        )
        
    }
    
    
    
    
    
    
    
    
    @IBOutlet weak var textText: UITextField!
    @IBOutlet weak var myImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var ref = DatabaseReference.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        let TapGaster = UITapGestureRecognizer()
        TapGaster.addTarget(self, action: #selector(ChatViewController.openGallary(tapGaster:)))
        myImageView.isUserInteractionEnabled = true
        myImageView.addGestureRecognizer(TapGaster)
       
    }
    
    @objc func openGallary(tapGaster:UITapGestureRecognizer){
       self.systemImagePicker()
    }

    
    @IBAction func btnSaveClick(_ sender: Any) {
        if self.myImageView.image == nil{
            let alertController = UIAlertController(title: "Error", message: "pleas select image", preferredStyle: .actionSheet)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
        saveFIRData()
        }}
    
    func saveFIRData(){
        self.uploadImage(self.myImageView.image!){ url in
            
            self.saveImage( profileURL: url!) {
                success in
                if success != nil {
                    print("yes ")
                }
            }
            
            
        }
    }
}



extension ChatViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    
    
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
        myImageView.image = image
        
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



extension ChatViewController {
    func uploadImage(_ image:UIImage,completion: @escaping (_ url: URL?) -> ()){
        let storegRRef = Storage.storage().reference(forURL: "gs://myhobbies-e447d.appspot.com/")
        let dateformat=DateFormatter()
        dateformat.dateFormat="MM_DD_yy_h_mm_a"
        let imageName=dateformat.string(from: NSDate() as Date )
        let ImagePah="images/\(imageName).jpg"
        let storegRef = storegRRef.child(ImagePah)
        let resizedImage = resizeImage(image: (myImageView.image)!, targetSize: CGSize.init(width: 414, height: 305))
        let imageData = resizedImage.pngData()
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
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
        let dict = ["profilPicture":profileURL.absoluteString] as [String:Any]
        self.ref.child("Test").childByAutoId().setValue(dict)
    }
}
