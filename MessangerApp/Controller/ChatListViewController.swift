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
        
        getContacts()
        
        contactsTableView.reloadData()
        configureTableView()
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewContact" {
            let destVC = segue.destination as! AddNewContactViewController
            print(self.currentUserLogin!)
            destVC.currentAccount = self.currentUserLogin!
        }
    }
    
    private func getContacts() {
        
        let dbref2 = db.collection("users").document((currentUserLogin!)).collection("contacts")
        
        
        print(currentUserLogin!)
        var tempArr : [ContactPerson] = [ContactPerson]()
        
        dbref2.getDocuments { (snapshot, error) in
            if let collection = snapshot?.documents {
                for item in collection {
                    let cp : ContactPerson = ContactPerson()
                
                    var testmsgArr : [Message] = [Message]()

                    let msg : Message = Message()
                    
                    msg.messageDate = " "
                    msg.messageText = ""
                    
                    testmsgArr.append(msg)
                    
                    cp.email = (item["email"]! as! String)
                    cp.PersonName = (item["login"]! as! String)
                    cp.message = testmsgArr
                    
                    tempArr.append(cp)
                }
            }
            
            print(tempArr)
            
            self.chatList = tempArr
            
            self.contactsTableView.reloadData()
        }
    }
    
}

