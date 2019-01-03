//
//  ChatListViewController.swift
//  MessangerApp
//
//  Created by Igor-Macbook Pro on 21/11/2018.
//  Copyright © 2018 Igor-Macbook Pro. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ChatListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var chatList : [ContactPerson] = [ContactPerson]()
    var currentUserLogin : String?
    let db = Firestore.firestore()
    
    var messageArray : [[Message]] = [[Message]]()
    
    @IBOutlet var addContactButton: UIButton!
    @IBOutlet var goToProfileButton: UIButton!
    
    var userName : String?
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        addContactButton.layer.cornerRadius = addContactButton.bounds.width / 2.5
        goToProfileButton.layer.cornerRadius = goToProfileButton.bounds.width / 2.5
        
        contactsTableView.reloadData()
        configureTableView()
        
        getLastMessages()
        
        contactsTableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "contactCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactsTableView.dequeueReusableCell(withIdentifier: "contactCell") as! ContactCell
        
        cell.configureContactCell(with: chatList[indexPath.row])
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = mainStoryBoard.instantiateViewController(withIdentifier: String(describing: MessageListViewController.self)) as! MessageListViewController
        
        contactsTableView.deselectRow(at: indexPath, animated: true)
        
        destinationVC.currentContact = chatList[indexPath.row]
        destinationVC.currentUserLogin = self.currentUserLogin

        self.navigationController?.pushViewController(destinationVC, animated: true)  
    }
    
    private func configureTableView() {
        contactsTableView.estimatedRowHeight = 180.0
    }
    
    @IBAction func addContactButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToNewContact", sender: self)
    }
    
    
    
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewContact" {
            let destVC = segue.destination as! AddNewContactViewController
            
            destVC.currentAccount = self.currentUserLogin!
        }
        
        if segue.identifier == "goToProfile" {
            let destVC = segue.destination as! ProfileViewController
            
            destVC.user = self.currentUserLogin!
        }
    }
    
    private func getLastMessages() {
        let dbref = db.collection("users").document((currentUserLogin!)).collection("contacts")
        
        
        var tempArr = [ContactPerson]()
    
        dbref.addSnapshotListener { (snapshot, error) in
            if let collection = snapshot?.documents {
                
                for item in collection {
                    let dbmesref = dbref.document((item["login"] as? String)!).collection("messages")
                    
                    dbmesref.addSnapshotListener({ (snapshot, error) in
                        if let collection = snapshot?.documents {
                            
                            let cp = ContactPerson()
                            var msgArr : [Message] = [Message]()
                            let msg : Message = Message()
                            
                            cp.email = (item["email"]! as! String)
                            cp.PersonName = (item["login"]! as! String)
                            
                            for item in collection {
                                
                                msg.messageDate = item["date"] as? String
                                msg.messageText = item["text"] as? String
                                msgArr.append(msg)
                                msgArr = msgArr.sorted(by: { $0.messageDate!.compare($1.messageDate!) == .orderedAscending })
                            }
                            cp.message = msgArr
                       
                            if tempArr.count > 0 {
                                for i in 0 ... tempArr.count - 1 {
                                    if tempArr[i].PersonName! == cp.PersonName! {
                                        tempArr[i] = cp
                                    }
                                    else {
                                        if i == tempArr.count - 1 {
                                            tempArr.append(cp)
                                        }
                                    }
                                }
                            }
                            else {
                                tempArr.append(cp)
                            }
                            
                            self.chatList = tempArr
                            self.contactsTableView.reloadData()
                        }
                    })
                }
            }
        }
    }
}

