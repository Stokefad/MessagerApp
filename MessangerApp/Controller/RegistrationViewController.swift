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

class RegistrationViewController : UIViewController {
  
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var fullNameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    let db = Firestore.firestore()
    

    
    let user : ContactPerson = ContactPerson()
    var messages : [Message] = [Message]()
    var contacts : [ContactPerson] = [ContactPerson]()
    let contacts1 : [ContactPerson] = [ContactPerson]() // test
    
    let contact : ContactPerson = ContactPerson()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        
        let msg : Message = Message() // msg for tests
        msg.messageDate = "fdsfds"
        msg.messageText = "QQ WORLD"
        messages.append(msg)
        
        contact.contacts = contacts
        contact.email = "dsf fjfdsd"
        contact.message = [msg]
        contact.PersonName = "ZDAROVA"
        
        contacts.append(contact)

    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (authRes, error) in
            if authRes != nil {
                self.createUserDB(login: self.fullNameTextfield.text!, email: self.emailTextfield.text!, messages: self.messages, contacts: self.contacts)
                self.performSegue(withIdentifier: "goToChatList", sender: self)
            }
            else {
                print("Bullshit happened")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ChatListViewController
        
        let user = createUserSystem(login: self.fullNameTextfield.text!, email: self.emailTextfield.text!, messages: self.messages, contacts: self.contacts)
        
        destVC.currentUserLogin = user.PersonName
    }
    
    private func createUserSystem(login : String, email : String, messages : [Message], contacts : [ContactPerson]) -> ContactPerson {
        user.contacts = contacts
        user.email = email
        user.PersonName = login
        user.message = messages
        
        return user
    }
    
    private func createUserDB(login : String, email : String, messages : [Message], contacts : [ContactPerson]) {
        db.collection("users").document(login).setData([
            "login" : login,
            "email" : email,
        ])
        db.collection("users").document(login).collection("contacts").document().setData([
            "email" : contacts[contacts.count - 1].email!,
            "login" : contacts[contacts.count - 1].PersonName!
        ])
        db.collection("users").document(login).collection("messages").document().setData([
            "text" : "AHDFLKHSDK kjefskjf flknsdfnsd",
            "date" : "\(Date.init())"
        ])
    }
}
