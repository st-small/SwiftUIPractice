//
//  ChatUser.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Stanly Shiyanovskiy on 12.07.2022.
//

import Foundation

struct ChatUser: Identifiable {
    var id: String { uid }
    let uid: String
    let email: String
    let profileImageUrl: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}
