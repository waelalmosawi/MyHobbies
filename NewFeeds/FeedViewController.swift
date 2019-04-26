//
//  FeedViewController.swift
//  MyHobbies
//
//  Created by Wael on 4/1/19.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit
import Firebase
class FeedViewController: UIViewController , UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    
    let myPickerData = ["Peter", "Jane", "Paul", "Mary", "Kevin", "Lucy"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerData.count
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myPickerData[row]
    }
    
    
    
    
  
    
    let thePicker = UIPickerView()
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "a", for: indexPath) as! CreatePostCell
            cell.SetImageR.addTarget(self, action:#selector(FeedViewController.heartTapped(_:)), for: .touchUpInside)
            func pickerView( pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
                cell.SelecttHobbies.text = myPickerData[row]
            }
            cell.SelecttHobbies.addTarget(self, action: #selector(FeedViewController.heartTapped(_:)), for: .touchUpInside)
        return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "b", for: indexPath)
            cell.textLabel?.text = "B"
            return cell
        }else{ let cell = tableView.dequeueReusableCell(withIdentifier: "c", for: indexPath)
        cell.textLabel?.text = "C"
            return cell}
        
    }
    
    
    
    
    
    
    var imagePicker:UIImagePickerController!
    var Waelimage = ""
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            //  picker is selected
            //load image to firebase
            //load images
            let storageRef = Storage.storage().reference(forURL: "gs://myhobbies-e447d.appspot.com/")
            // Points to "images"
            // let imagesRef = storageRef.child("images")
            var data = NSData()
            data = image.jpegData(compressionQuality: 0.8)! as NSData
            let dateformat=DateFormatter()
            dateformat.dateFormat="MM_DD_yy_h_mm_a"
            let imageName=dateformat.string(from: NSDate() as Date )
            let ImagePah="images/\(imageName).jpg"
            // Create storage reference
            let mountainsRef = storageRef.child(ImagePah)
            // Create file metadata including the content type
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            // Upload data and metadata
            mountainsRef.putData(data as Data, metadata: metadata)
            Waelimage = ImagePah
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @objc func heartTapped(_ sender: Any?) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        thePicker.delegate = self
        imagePicker=UIImagePickerController()
        imagePicker.delegate=self

        // Do any additional setup after loading the view.
    }
    


}
