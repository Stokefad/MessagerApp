//
//  ProfileViewController.swift
//  MessangerApp
//
//  Created by Igor-Macbook Pro on 02/01/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import UIKit

class ProfileViewController : UIViewController {
    
    @IBOutlet weak var mainImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainImage.image = UIImage(named: "bugatti")
        
    }
    
    
    
    
}
