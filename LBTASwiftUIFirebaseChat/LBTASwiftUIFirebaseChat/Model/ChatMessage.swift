//
//  ChatMessage.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Stanly Shiyanovskiy on 13.07.2022.
//

import FirebaseFirestoreSwift
import Foundation

struct FirebaseConstants {
    static let uid = "uid"
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let timestamp = "timestamp"
    static let profileImageUrl = "profileImageUrl"
    static let email = "email"
}

struct ChatMessage: Codable, Identifiable {
    
    @DocumentID var id: String?
    
    let fromId: String
    let toId: String
    let text: String
    let timestamp: Date
}
