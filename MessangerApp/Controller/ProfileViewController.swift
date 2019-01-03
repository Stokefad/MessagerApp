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

class ProfileViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user : String?
    
    @IBOutlet weak var mainImage: UIImageView!
    
    let db = Firestore.firestore()
    let imagePicker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        
        if mainImage.image == nil {
            mainImage.image = UIImage(named: "bugatti")
        }
        else {
            
        }
        
    }
    
    private func saveImage(image : UIImage) {
        let dbref = db.collection("users").document(user!)
        
        dbref.setData([
            "image" : image
        ])
    }
    
    private func getImage() {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            mainImage.image = userPickedImage
            saveImage(image: mainImage.image!)
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
