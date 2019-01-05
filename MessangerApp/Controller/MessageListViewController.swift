//
//  MessageListViewController.swift
//  MessangerApp
//
//  Created by Igor-Macbook Pro on 23/11/2018.
//  Copyright © 2018 Igor-Macbook Pro. All rights reserved.
//

import UIKit
import Firebase

class MessageListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var currentContact : ContactPerson?
    var currentUserLogin : String?
    var messagesArray : [Message] = [Message]()
    var currentImage : UIImage?
    
    
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    let db = Firestore.firestore()
    
    
    @IBOutlet var msgTextfield: UITextField!
    @IBOutlet var msgTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        msgTableView.delegate = self
        msgTableView.dataSource = self
        msgTextfield.delegate = self
        
        msgTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "msgCell")
        
        let gestRec = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.msgTableView.addGestureRecognizer(gestRec)

        getMessages()
        
        configureTableView()
        
        msgTableView.reloadData()
    }
    
    
    private func configureTableView() {
        msgTableView.rowHeight = UITableView.automaticDimension
        msgTableView.rowHeight = 100
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if messagesArray.count > 0 {
            msgTableView.scrollToRow(at: IndexPath(row: messagesArray.count - 1, section: 0), at: .bottom, animated: false)
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = msgTableView.dequeueReusableCell(withIdentifier: "msgCell") as! MessageCell
        
        cell.configureCell(with: messagesArray[indexPath.row])
        
        msgTableView.scrollToRow(at: IndexPath(row: messagesArray.count - 1, section: 0), at: .bottom, animated: true)
        
        return cell
    }
    
    
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        let newMsg = Message()
        
        newMsg.messageDate = "\(Date.init())"
        newMsg.messageText = msgTextfield.text!
        
        saveMessage(text: newMsg.messageText!, date: "\(newMsg.messageDate!)", sender: (Auth.auth().currentUser?.email!)!)
        
        messagesArray.append(newMsg)
        
        msgTableView.reloadData()
        
        msgTextfield.text = ""
    }
    
    private func saveMessage(text : String, date : String, sender : String) {
        let dbref = db.collection("users").document(currentUserLogin!).collection("contacts").document((currentContact?.PersonName!)!).collection("messages")
        
        let dbrefGetter = db.collection("users").document((currentContact?.PersonName!)!).collection("contacts").document(currentUserLogin!).collection("messages")
        
        dbrefGetter.addDocument(data: [
            "text" : text,
            "date" : date,
            "sender" : sender
        ])
        
        dbref.addDocument(data: [
            "text" : text,
            "date" : date,
            "sender" : sender
        ])
        
        // in current contacts
        
        db.collection("users").document(currentUserLogin!).collection("contacts").document((currentContact?.PersonName!)!).setData([
            "login" : currentContact?.PersonName! as Any,
            "email" : currentContact?.email! as Any,
        ])
        
        // reverse
        
        db.collection("users").document((currentContact?.PersonName!)!).collection("contacts").document(currentUserLogin!).setData([
            "login" : currentUserLogin! as Any,
            "email" : Auth.auth().currentUser?.email! as Any
        ])
    }
    
    
    
    
    
    private func getMessages() {
        let dbref = db.collection("users").document(currentUserLogin!).collection("contacts").document((currentContact?.PersonName!)!).collection("messages")
        
        dbref.addSnapshotListener { (snapshot, error) in
            if let collection = snapshot?.documents {
                
                var tempArr : [Message] = [Message]()
                
                for item in collection {
                    let msg : Message = Message()
                    
                    msg.messageDate = item["date"] as? String
                    msg.messageText = item["text"] as? String
                    msg.sender = item["sender"] as? String
                    
                    tempArr.append(msg)
                }
                
                let resArr = tempArr.sorted(by: { $0.messageDate!.compare($1.messageDate!) == .orderedAscending })
                
                self.messagesArray = resArr
                self.msgTableView.reloadData()
            }
        }
    }
    
    
    @IBOutlet weak var textboxView: UIView!
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.bottom.constant = self.keyboardH + 15
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.bottom.constant = 15
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func endEditing() {
        msgTextfield.endEditing(true)
    }
    
    var keyboardH : CGFloat = 0
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardH = keyboardRectangle.height
        }
    }
}
