//
//  Message.swift
//  Instagram Clone
//
//  Created by Lumbaram Choudhary on 20/07/22.
//

import Foundation
import Firebase

struct ChatModel {
    var chatId: String
    var username: String
    var message: String
    
    init?(chatId: String, dict: [String:Any]) {
        self.chatId = chatId
        guard let username = dict["username"] as? String,
              let message = dict["message"] as? String else { return nil}
        self.username = username
        self.message = message
    }
}

struct ChatSnapShot {
    let chats: [ChatModel]
    init?(snapshot: DataSnapshot) {
        var chats = [ChatModel]()
        guard let snapDict = snapshot.value as? [String: [String: Any]] else { return nil}
        for snap in snapDict {
            guard let chat = ChatModel(chatId: snap.key, dict: snap.value) else { continue }
            chats.append(chat)
        }
        self.chats = chats
    }
}
