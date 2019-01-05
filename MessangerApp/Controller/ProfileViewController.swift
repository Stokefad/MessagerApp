//
//  ProfileViewController.swift
//  MessangerApp
//
//  Created by Igor-Macbook Pro on 02/01/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import UIKit
import Vision
import FirebaseFirestore
import Firebase

class ProfileViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user : String?
    var image : UIImage = UIImage()
    
    @IBOutlet weak var mainImage: UIImageView!
    
    let db = Firestore.firestore()
    let imagePicker = UIImagePickerController()
    
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
    
        if mainImage.image != nil {
            getImage()
        }
        else {
            mainImage.image = UIImage(named: "bugatti")
        }
        
    }
    
    private func saveImage(image : UIImage) {
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("images")
        
        let singleImage = imagesRef.child(user!)
        var data = Data()
        data = image.pngData()!
        
        let uploadTask = singleImage.putData(data, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                return
            }
        }
    }
    
    private func getImage() {
        let imagePath = storage.reference().child("images").child(user!)
        
        imagePath.getData(maxSize: 1 * 1024 * 1024 * 1024) { (data, error) in
            if error != nil {
                print("Problems with downloading image occured \(String(describing: error))")
            }
            else {
                self.mainImage.image = UIImage(data: data!)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            mainImage.image = userPickedImage
            saveImage(image: userPickedImage)
        }
        else {
            print("Error with image occured")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func setPicturePressed(_ sender: UIButton) {
        present(imagePicker, animated: true)
    }
    
    
}
