//
//  ViewController.swift
//  MessangerApp
//
//  Created by Igor-Macbook Pro on 18/11/2018.
//  Copyright © 2018 Igor-Macbook Pro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        signinButton.layer.cornerRadius = 12
        registerButton.layer.cornerRadius = 12
        
    }

    @IBOutlet var signinButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    
    @IBAction func registrationButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToRegistration", sender: self)
    }
}


