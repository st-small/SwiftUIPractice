//
//  ChatLogView.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Stanly Shiyanovskiy on 13.07.2022.
//

import Firebase
import FirebaseFirestoreSwift
import SwiftUI

final class ChatLogViewModel: ObservableObject {
    
    @Published var chatText = ""
    @Published var errorMessage = ""
    
    @Published var chatMessages = [ChatMessage]()
    @Published var count = 0
    
    var chatUser: ChatUser?
    
    var firestoreListener: ListenerRegistration?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        firestoreListener?.remove()
        chatMessages.removeAll()
        firestoreListener = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { [weak self] querySnapshot, error in
                if let error = error {
                    self?.errorMessage = "Failed to listen for messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach { change in
                    if change.type == .added {
                        if let cm = try? change.document.data(as: ChatMessage.self) {
                            self?.chatMessages.append(cm)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self?.count += 1
                }
            }
    }
    
    func handleSend() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = [
            FirebaseConstants.fromId: fromId,
            FirebaseConstants.toId: toId,
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.timestamp: Timestamp()
        ] as [String : Any]
        
        let msg = ChatMessage(id: nil, fromId: fromId, toId: toId, text: chatText, timestamp: Date())
        
        try? document.setData(from: msg) { [weak self] error in
            if let error = error {
                print(error)
                self?.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Successfully saved current user sending message")
            
            self?.persistRecentMessage()
            
            self?.chatText = ""
            self?.count += 1
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        recipientMessageDocument.setData(messageData) { [weak self] error in
            if let error = error {
                print(error)
                self?.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Recipient saved message as well")
        }
    }
    
    private func persistRecentMessage() {
        guard let chatUser = chatUser else { return }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = self.chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toId)
        
        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
            FirebaseConstants.email: chatUser.email
        ] as [String : Any]
        
        // you'll need to save another very similar dictionary for the recipient of this message...how?
        
        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print("Failed to save recent message: \(error)")
                return
            }
        }
        
//        guard let currentUser = FirebaseManager.shared.currentUser else { return }
//        let recipientRecentMessageDictionary = [
//            FirebaseConstants.timestamp: Timestamp(),
//            FirebaseConstants.text: chatText,
//            FirebaseConstants.fromId: uid,
//            FirebaseConstants.toId: toId,
//            FirebaseConstants.profileImageUrl: currentUser.profileImageUrl,
//            FirebaseConstants.email: currentUser.email
//        ] as [String : Any]
//        
//        FirebaseManager.shared.firestore
//            .collection("recent_messages")
//            .document(toId)
//            .collection("messages")
//            .document(currentUser.uid)
//            .setData(recipientRecentMessageDictionary) { error in
//                if let error = error {
//                    print("Failed to save recipient recent message: \(error)")
//                    return
//                }
//            }
    }
}

struct ChatLogView: View {
    
    @ObservedObject var vm: ChatLogViewModel
    
    static let emptyScrollToString = "Empty"
    
    var body: some View {
        ZStack {
            messagesView
            Text(vm.errorMessage)
            
            VStack(spacing: 0) {
                Spacer()
                chatBottomBar
                    .background(Color.white.ignoresSafeArea())
            }
            
        }
        .navigationTitle(vm.chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            vm.firestoreListener?.remove()
        }
    }
    
    private var messagesView: some View {
        ScrollView {
            ScrollViewReader { proxy in
                VStack {
                    ForEach(vm.chatMessages) { message in
                        MessageView(message: message)
                    }
                    
                    HStack { Spacer() }
                        .id(Self.emptyScrollToString)
                        .frame(height: 50)
                }
                .onReceive(vm.$count) { _ in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        proxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                    }
                }
            }
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)
            
            Button {
                vm.handleSend()
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct MessageView: View {
    
    let message: ChatMessage
    
    var body: some View {
        VStack {
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                HStack {
                    Spacer()
                    HStack {
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            } else {
                HStack {
                    HStack {
                        Text(message.text)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    Spacer()
                }
                
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Description")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}
