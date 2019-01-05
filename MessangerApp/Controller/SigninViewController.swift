//
//  SigninViewController.swift
//  MessangerApp
//
//  Created by Igor-Macbook Pro on 19/11/2018.
//  Copyright © 2018 Igor-Macbook Pro. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SigninViewController : UIViewController, UITextFieldDelegate {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet var signinButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestRec = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.view.addGestureRecognizer(gestRec)
        
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        signinButton.layer.cornerRadius = 12
        
    }
    
    
    @objc private func endEditing() {
        emailTextfield.endEditing(true)
        passwordTextfield.endEditing(true)
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        signIn(login: emailTextfield.text!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ChatListViewController
        
        destVC.currentUserLogin = emailTextfield.text!
    }
    
    private func signIn(login : String) {
        let dbref = db.collection("users").document(login)
        
        dbref.getDocument { (snapshot, error) in
            if let data = snapshot?.data() {
                let email = data["email"] as? String
                print(email!)
                Auth.auth().signIn(withEmail: email!, password: self.passwordTextfield.text!, completion: { (result, error) in
                    if result != nil {
                        self.performSegue(withIdentifier: "goToChatList", sender: self)
                    }
                    else {
                        print("This is email: \(email!)")
                        print("Problem with logging in occured")
                    }
                })
            }
        }
    }
}
