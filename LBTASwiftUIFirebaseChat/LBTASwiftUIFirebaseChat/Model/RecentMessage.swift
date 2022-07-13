//
//  RecentMessage.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Stanly Shiyanovskiy on 13.07.2022.
//

import FirebaseFirestoreSwift
import Foundation

struct RecentMessage: Codable, Identifiable {

    @DocumentID var id: String?

    let text: String
    let email: String
    let fromId: String
    let toId: String
    let profileImageUrl: String
    let timestamp: Date
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}
