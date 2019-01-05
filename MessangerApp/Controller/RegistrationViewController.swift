//
//  RegistrationViewController.swift
//  MessangerApp
//
//  Created by Igor-Macbook Pro on 19/11/2018.
//  Copyright © 2018 Igor-Macbook Pro. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class RegistrationViewController : UIViewController, UITextFieldDelegate {
  
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var fullNameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    let db = Firestore.firestore()
    

    @IBOutlet var registerButton: UIButton!
    
    let user : ContactPerson = ContactPerson()
    var messages : [Message] = [Message]()
    var contacts : [ContactPerson] = [ContactPerson]()
    let contacts1 : [ContactPerson] = [ContactPerson]() // test
    
    let contact : ContactPerson = ContactPerson()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestRec = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.view.addGestureRecognizer(gestRec)
        
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        fullNameTextfield.delegate = self
        
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        registerButton.layer.cornerRadius = 12

    }
    
    @objc private func endEditing() {
        emailTextfield.endEditing(true)
        passwordTextfield.endEditing(true)
        fullNameTextfield.endEditing(true)
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (authRes, error) in
            if authRes != nil {
                self.createUserDB(login: self.fullNameTextfield.text!, email: self.emailTextfield.text!)
                self.performSegue(withIdentifier: "goToChatList", sender: self)
            }
            else {
                print("Bullshit happened")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ChatListViewController
        
        destVC.currentUserLogin = fullNameTextfield.text!
    }
    
    private func createUserDB(login : String, email : String) {
        db.collection("users").document(login).setData([
            "login" : login,
            "email" : email,
        ])
    }
}
