//
//  NewChatViewController.swift
//  Instagram Clone
//
//  Created by Lumbaram Choudhary on 20/07/22.
//

import UIKit
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}


class NewChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {

    let currentUser = Sender(senderId: "self", displayName: "abc")
    let otherUser = Sender(senderId: "other", displayName: "xyz")
    var messages = [Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //messages.append(Message(sender: currentUser, messageId: "1", sentDate: Date(), kind: .photo(Media(url: nil, image: UIImage(named: "5"), placeholderImage: UIImage(named: "5")!, size: CGSize(width: 250, height: 100)))))
        messages.append(Message(sender: currentUser, messageId: "1", sentDate: Date(), kind: .text("hii")))
        messages.append(Message(sender: otherUser, messageId: "2", sentDate: Date(), kind: .text("hello")))
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    
    func currentSender() -> SenderType {
        currentUser
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
//    func insertMessage(message: Message) {
//        messages.append(message)
//        self.messagesCollectionView.reloadData()
//    }
}
