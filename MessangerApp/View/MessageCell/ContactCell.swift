//
//  ContactCell.swift
//  MessangerApp
//
//  Created by Igor-Macbook Pro on 19/11/2018.
//  Copyright © 2018 Igor-Macbook Pro. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var lastMessageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var contactImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    
    
    
    public func configureContactCell(with contact : ContactPerson) {
        nameLabel.text = contact.PersonName
        lastMessageLabel.text = contact.message[contact.message.count - 1].messageText
        dateLabel.text = "Сообщение отправлено: \(String(describing: contact.message[contact.message.count - 1].messageDate))"
  //      contactImage.image = contact.image
    }
    
}
