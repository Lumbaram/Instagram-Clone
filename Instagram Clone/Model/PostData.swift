// 
//  PostData.swift
//  Instagram Clone
//
//  Created by Lumbaram Choudhary on 14/07/22.
//

import Foundation
import Firebase

struct PostData {
    var postId: String
    var username: String
    var message: String
    var imageUrl: String
    
    init(postId: String, username: String, message: String, imageUrl: String) {
        self.postId = postId
        self.username = username
        self.message = message
        self.imageUrl = imageUrl
    }
}



