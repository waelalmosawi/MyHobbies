//
//  CreateAccountPageTwo.swift
//  MyHobbies
//
//  Created by Wael on 3/21/19.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit

class CreateAccountPageTwo: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate  {
    @IBOutlet weak var IMG: UIImageView!
    @IBOutlet weak var Selected: UILabel!
    @IBOutlet weak var SelectedLab: UILabel!
    @IBOutlet weak var NextBB: UIButton!
    var cellWidth:CGFloat = 0
    var cellHeight:CGFloat = 0
    var spacing:CGFloat = 12
    var numberOfColumn:CGFloat = 2
    
    var arrData = [String]() // This is your data array
    var arrSelectedIndex = [IndexPath]() // This is selected cell Index array
     // This is selelected cell Data array
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurEffect(img: IMG)
        NextBB.backgroundColor = UIColor.lightGray
        MyCollectionView.contentInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        if let flowLayout = MyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            cellWidth = (MyCollectionView.frame.width  - (numberOfColumn + 1)*spacing)/numberOfColumn
            cellHeight = 100 //yourCellHeight
            flowLayout.minimumLineSpacing = spacing
            flowLayout.minimumInteritemSpacing = spacing
        }
        MyCollectionView.register(UINib(nibName: "wewe", bundle: nil), forCellWithReuseIdentifier: "wewe")
        MyCollectionView.allowsMultipleSelection=true
        arrData.append("A")
        arrData.append("B")
        arrData.append("C")
        arrData.append("D")
        arrData.append("E")
        arrData.append("F")
        arrData.append("G")
        arrData.append("H")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wewe", for: indexPath) as! wewe
        cell.Mylab.text = arrData[indexPath.row]
        if arrSelectedIndex.contains(indexPath) {
            // You need to check wether selected index array contain current index if yes then change the color
            cell.View.backgroundColor = UIColor.red
        }
        else {
            cell.View.backgroundColor = UIColor.blue
        }
        cell.layoutSubviews()
        return cell
    }
   
    //DidSelect
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        //SelectedItem.text = "you select \(String(arrSelectedData.count)) hobbies "
        print("You selected cell #\(indexPath.item)!")
        let strData = arrData[indexPath.item]
        
        if arrSelectedIndex.contains(indexPath) {
            arrSelectedIndex = arrSelectedIndex.filter { $0 != indexPath}
            arrSelectedData = arrSelectedData.filter { $0 != strData}
            
        }
        else {
            arrSelectedIndex.append(indexPath)
            arrSelectedData.append(strData)
        }
        if arrSelectedIndex.count >= 3 {
            NextBB.backgroundColor = UIColor.green
        }else {
             NextBB.backgroundColor = UIColor.lightGray
        }
        
        if arrSelectedIndex.count == 0 {
            Selected.text = "Please select three or more hobbies"
        }else {
            Selected.text = "You are select \(arrSelectedIndex.count) hobbies"
        }
        MyCollectionView.reloadData()
    }
    
    
    
    @IBOutlet weak var MyCollectionView: UICollectionView!
    
    @IBAction func Next(_ sender: Any) {
        
        if arrSelectedIndex.count >= 3 {
             performSegue(withIdentifier: "SingUpPageThree", sender: nil)
        }else {
            let alertController = UIAlertController(title: "Error", message: "Please chose 3 or more Hobbies", preferredStyle: .actionSheet)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
       
    }
    }
    }

