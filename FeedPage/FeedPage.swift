//
//  FeedPage.swift
//  
//
//  Created by Wael on 3/31/19.
//

import UIKit
import Firebase
class FeedPage: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var profIMGG: UIImageView!
    @IBOutlet weak var ProfileIMG: RoundedImageView!
    @IBOutlet weak var NameLAB: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var MyNameView: UIView!
    @IBOutlet weak var PostButton: UIButton!
    @IBOutlet weak var PostView: UIView!
    @IBOutlet weak var CoverPhoto: UIImageView!
    @IBOutlet weak var btnNumberOfRooms: UIButton!
    @IBOutlet weak var tblDropDownHC : NSLayoutConstraint!
    @IBOutlet weak var tblDropDown: UITableView!
    
    
    var isTableVisible = false
    let imagePicker = UIImagePickerController()
    var ref = DatabaseReference.init()
    func blurEffect() {
        let darkBlur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = CoverPhoto.bounds
        CoverPhoto.addSubview(blurView)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Hobbies.count
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell = tableView.dequeueReusableCell(withIdentifier: "Wael")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "Wael")
            }
            cell?.textLabel?.text = Hobbies[indexPath.row]
            return cell!
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Hobbie = Hobbies[indexPath.row]
        btnNumberOfRooms.setTitle("\(Hobbies[indexPath.row])", for: .normal)
        UIView.animate(withDuration: 0.5) {
            self.tblDropDownHC.constant = 0
            self.isTableVisible = false
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func SelctHobbies( _ snder : AnyObject){
        tblDropDown.reloadData()
        UIView.animate(withDuration: 0.5) {
            if self.isTableVisible == false {
                self.isTableVisible = true
                self.tblDropDownHC.constant = 44.0 * 3.0
            } else {
                self.tblDropDownHC.constant = 0
                self.isTableVisible = false
            }
            self.view.layoutIfNeeded()
        }
    }
    var UName :String!
    var UProfIMG : String!
    func loadUserName(){
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("MyUser").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["Name"] as? String ?? ""
            let IMG = value?["ImagePath"] as? String ?? ""
            self.ProfileIMG.sd_setImage(with:URL(string:IMG))
            self.profIMGG.sd_setImage(with:URL(string:IMG))
            self.UProfIMG = IMG
            self.NameLAB.text = username
            self.UName = username
        }
        )
    }
    // Hobbies Download
    func LoadMessages(){
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        ref.child("MySelectedHob").child(userID!).observeSingleEvent(of:.value, with: { (snapshot) in
            Hobbies.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if  let Hobbiess = snap.value as? String {
                        Hobbies.append(Hobbiess)
                        // Get user value
                    }
                    // ...
                }
                self.tblDropDown.reloadData()
            }})}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurEffect(img:ProfileIMG)
        hideKeyboardWhenTappedAround()
        btnNumberOfRooms.layer.cornerRadius = 15
        PostButton.layer.cornerRadius = 15
        PostView.layer.cornerRadius = 20
        PostView.layer.shadowRadius = 20
        MyNameView.layer.cornerRadius = 35
        MyNameView.layer.shadowRadius = 35
        self.ref=Database.database().reference()
        LoadMessages()
        blurEffect()
        loadUserName()
        tblDropDown.delegate   = self
        tblDropDown.dataSource = self
        tblDropDownHC.constant = 0
        
    }
    
    @IBOutlet weak var PostTextField: UITextView!
    
    
    
    var Hobbie = "" //selected hobbie
    var UserName:String? //current User name loded from database
    
    
    
    
    func saveFIRData(){
        let UUID = Auth.auth().currentUser?.uid
        if myImageView.image == nil{
            savePost(UID: UUID!,PostText: self.PostTextField.text!, profileURL: "")
        }else{
            self.uploadImage(self.myImageView.image!){ url in
                self.saveImage( UID: UUID!, PostText: self.PostTextField.text!, profileURL: url!) {
                    success in
                    if success != nil {
                        print("yes ")
                    }
                }
            }
        }
    }

    
    @IBAction func Sinfbbbb(_ sender: Any) {
        saveFIRData()
        
        
        
        
        //performSegue(withIdentifier: "Back", sender: nil)
    }
    
   
    
    @IBAction func ChoseImage(_ sender: Any) {
       self.systemImagePicker()
}
}
extension FeedPage: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    
    
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
var wael = ""
extension FeedPage {
    func uploadImage(_ image:UIImage,completion: @escaping (_ url: URL?) -> ()){
        let storegRRef = Storage.storage().reference(forURL: "gs://myhobbies-e447d.appspot.com/")
        let resizedImage = resizeImage(image: (myImageView.image)!, targetSize: CGSize.init(width: 414, height: 305))
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
    
    
    
    func savePost(UID:String,PostText:String,profileURL:String){
        let dict = ["UID":UID,"text":PostTextField.text!,"ImagePath":"No_Image"] as [String:Any]
        self.ref.child("MyHob").child(Hobbie).childByAutoId().setValue(dict)
    }
    func saveImage(UID:String,PostText:String,profileURL:URL,completion: @escaping ((_ url: URL?) -> ())){
            let dict = ["UID":UID,"text":PostTextField.text!,"ImagePath":profileURL.absoluteString] as [String:Any]
            self.ref.child("MyHob").child(Hobbie).childByAutoId().setValue(dict)
    }
}
