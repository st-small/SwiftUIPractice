//
//  FirebaseManager.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Stanly Shiyanovskiy on 12.07.2022.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
import Foundation

final class FirebaseManager: NSObject {
    
    static let shared = FirebaseManager()
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    private override init() {
        FirebaseApp.configure()
        
        auth = Auth.auth()
        storage = Storage.storage()
        firestore = Firestore.firestore()
        
        super.init()
    }
}
