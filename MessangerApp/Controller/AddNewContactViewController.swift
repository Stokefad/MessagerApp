//
//  AddNewContactViewController.swift
//  MessangerApp
//
//  Created by Igor-Macbook Pro on 23/11/2018.
//  Copyright © 2018 Igor-Macbook Pro. All rights reserved.
//

import UIKit
import Firebase

class AddNewContactViewController : UIViewController {
    
    let db = Firestore.firestore()
    
    var currentAccount : String?
    
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var addUserButtonPressed: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentAccount!)
        label.text = ""
        
        addButton.layer.cornerRadius = 21
    }
    
    @IBAction func addUserButtonPressed(_ sender: UIButton) {
        print(label.text!)
        searchUsername(newLogin: usernameTextfield.text!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ChatListViewController
        
        destVC.userName = label.text
        print(self.currentAccount!)
        destVC.currentUserLogin = self.currentAccount!
    }
    
    private func searchUsername(newLogin : String) {
        let dbref = db.collection("users")
        
        dbref.getDocuments { (snapshot, error) in
            if let collection = snapshot?.documents {
                for item in collection {
                    if item.data()["login"] as! String == newLogin {
                        
                        let data = item.data()
                        
                        self.updateUserDB(login: data["login"] as! String, email: data["email"] as! String, curUser: self.currentAccount!)
                        
                        self.performSegue(withIdentifier: "goToChatListAgain", sender: self)
                        return
                    }
                }
                self.label.text = "User with this username not exists"
            }
        }
    }
    
    private func updateUserDB(login : String, email : String, curUser : String) {
        db.collection("users").document(curUser).collection("contacts").document(login).setData([
            "email" : email,
            "login" : login
            ])
    }
}
