//
//  MessageCell.swift
//  MessangerApp
//
//  Created by Igor-Macbook Pro on 19/11/2018.
//  Copyright © 2018 Igor-Macbook Pro. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    
    @IBOutlet var msgText: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configureCell(with message : Message) {
        msgText.text = message.messageText
        nameLabel.text = message.sender
        
        let dateF = DateFormatter()
        
        dateF.dateStyle = .medium
        dateF.timeStyle = .short
        
        date.text = message.messageDate
    }
    
}
