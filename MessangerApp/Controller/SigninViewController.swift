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

class SigninViewController : UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet var loginTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextfield.text ?? "", password: passwordTextfield.text ?? "") { (authRes, error) in
            if authRes != nil {
                self.performSegue(withIdentifier: "goToChatList", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ChatListViewController
        
        destVC.currentUserLogin = loginTextfield.text!
    }
    
    
    
    private func getUser(login : String) -> ContactPerson? {
        let docRef = db.collection("users").document("Puppy")

        let cp : ContactPerson = ContactPerson()
        print("YA TUT")
        docRef.getDocument { (snapshot, error) in
            let data = snapshot!.data()!
            
            cp.email = (data["email"] as! String)
            print((data["email"] as! String))
            cp.PersonName = (data["login"] as! String)
        }
        return cp
    }
}