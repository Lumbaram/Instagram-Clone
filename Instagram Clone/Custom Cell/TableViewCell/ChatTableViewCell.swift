//
//  ChatTableViewCell.swift
//  Instagram Clone
//
//  Created by Lumbaram Choudhary on 15/07/22.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    // MARK: IBOutlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var message2Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.layer.cornerRadius = 15
        messageLabel.layer.masksToBounds = true
        message2Label.layer.cornerRadius = 15
        message2Label.layer.masksToBounds = true
    }
    // MARK: Variable
    var chatModel: ChatModel? {
        didSet {
            messageLabel.text = chatModel?.message
            message2Label.text = chatModel?.message
        }
    }
    
}
