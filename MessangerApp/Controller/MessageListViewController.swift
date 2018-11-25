//
//  MessageListViewController.swift
//  MessangerApp
//
//  Created by Igor-Macbook Pro on 23/11/2018.
//  Copyright © 2018 Igor-Macbook Pro. All rights reserved.
//

import UIKit
import Firebase

class MessageListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentContact : ContactPerson?
    var currentUserLogin : String?
    var messagesArray : [Message] = [Message]()
    
    let db = Firestore.firestore()
    
    
    @IBOutlet var msgTextfield: UITextField!
    @IBOutlet var msgTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        msgTableView.delegate = self
        msgTableView.dataSource = self
        
        msgTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "msgCell")

        getMessages()
        
        msgTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = msgTableView.dequeueReusableCell(withIdentifier: "msgCell") as! MessageCell
        
        cell.configureCell(with: messagesArray[indexPath.row])
        
        return cell
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        let newMsg = Message()
        
        newMsg.messageDate = "\(Date.init())"
        newMsg.messageText = msgTextfield.text!
        
        saveMessage(text: newMsg.messageText!, date: newMsg.messageDate!)
        
        messagesArray.append(newMsg)
        
        msgTableView.reloadData()
    }
    
    private func saveMessage(text : String, date : String) {
        let dbref = db.collection("users").document(currentUserLogin!).collection("contacts").document((currentContact?.PersonName!)!).collection("messages")
        
        let dbrefGetter = db.collection("users").document((currentContact?.PersonName!)!).collection("contacts").document(currentUserLogin!).collection("messages")
        
        dbrefGetter.addDocument(data: [
            "text" : text,
            "date" : date
        ])
        
        dbref.addDocument(data: [
            "text" : text,
            "date" : date
        ])
        
        // in current contacts
        
        db.collection("users").document(currentUserLogin!).collection("contacts").document((currentContact?.PersonName!)!).setData([
            "login" : currentContact?.PersonName! as Any,
            "email" : currentContact?.email! as Any,
            ])
        
        // reverse
        
        db.collection("users").document((currentContact?.PersonName!)!).collection("contacts").document(currentUserLogin!).setData([
            "login" : currentUserLogin! as Any,
            ])
    }
    
    private func getMessages() {
        let dbref = db.collection("users").document(currentUserLogin!).collection("contacts").document((currentContact?.PersonName!)!).collection("messages")
        
        dbref.getDocuments { (snapshot, error) in
            if let collection = snapshot?.documents {
                for item in collection {
                    let msg : Message = Message()
                    
                    msg.messageDate = item["date"] as? String
                    msg.messageText = item["text"] as? String
                    
                    self.messagesArray.append(msg)
                }
            }
        }
    }
    
}
