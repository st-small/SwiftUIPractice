//
//  MainMessagesView.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Stanly Shiyanovskiy on 12.07.2022.
//

import Firebase
import FirebaseFirestoreSwift
import SDWebImageSwiftUI
import SwiftUI

final class MainMessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var recentMessages = [RecentMessage]()
    
    @Published var isUserCurrentlyLoggedOut = false
    
    private var firestoreListener: ListenerRegistration?
    
    init() {
        
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
        fetchRecentMessages()
    }
    
    func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        firestoreListener?.remove()
        recentMessages.removeAll()
        
        firestoreListener = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { [weak self] querySnapshot, error in
                if let error = error {
                    self?.errorMessage = "Failed to listen for recent messages: \(error)"
                    return
                }
                
                querySnapshot?.documentChanges.forEach { change in
                    let docID = change.document.documentID
                    
                    if let index = self?.recentMessages.firstIndex(where: { $0.id == docID }) {
                        self?.recentMessages.remove(at: index)
                    }
                    
                    if let rm = try? change.document.data(as: RecentMessage.self) {
                        self?.recentMessages.insert(rm, at: 0)
                    }
                }
            }
    }
    
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            errorMessage = "Could not find firebase uid"
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            if let error = error {
                self?.errorMessage = "Failed to fetch current user: \(error)"
                return
            }
            
            guard let data = snapshot?.data() else {
                self?.errorMessage = "No data found"
                return
            }
            
            self?.chatUser = ChatUser(data: data)
        }
    }
    
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
}

struct MainMessagesView: View {
    
    @State var shouldShowLogOutOptions = false
    @State var shouldShowNewMessageScreen = false
    @State var chatUser: ChatUser?
    
    @State var shouldNavigateToChatLogView = false
    
    @ObservedObject
    private var vm = MainMessagesViewModel()
    
    private var chatLogViewModel = ChatLogViewModel(chatUser: nil)
    
    var body: some View {
        NavigationView {
            
            VStack {
                customNavBar
                messagesView
                
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                    ChatLogView(vm: chatLogViewModel)
                }
            }
            .overlay(
                newMessageButton, alignment: .bottom
            )
            .navigationBarHidden(true)
        }
    }
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            
            WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(vm.chatUser?.email.components(separatedBy: "@").first ?? "")")
                    .font(.system(size: 24, weight: .bold))
                
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
            }
            
            Spacer()
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
            
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            ActionSheet(
                title: Text("Settings"),
                message: Text("What do you want to do?"),
                buttons: [
                    .destructive(Text("Sign Out")) {
                        vm.handleSignOut()
                    },
                    .cancel()
                ]
            )
        }
        .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut) {
            LoginView(didCompleteLoginProcess: {
                vm.isUserCurrentlyLoggedOut = false
                vm.fetchCurrentUser()
                vm.fetchRecentMessages()
            })
        }
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(vm.recentMessages) { recentMessage in
                VStack {
                    Button {
                        let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
                        chatUser = ChatUser(data: [
                            FirebaseConstants.email: recentMessage.email,
                            FirebaseConstants.profileImageUrl: recentMessage.profileImageUrl,
                            FirebaseConstants.uid: uid
                        ])
                        chatLogViewModel.chatUser = chatUser
                        chatLogViewModel.fetchMessages()
                        shouldNavigateToChatLogView.toggle()
                    } label: {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: recentMessage.profileImageUrl))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 64, height: 64)
                                .clipped()
                                .cornerRadius(32)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 32)
                                        .stroke(Color(.label), lineWidth: 1)
                                )
                                .shadow(radius: 5)
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(recentMessage.email)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(.label))
                                Text(recentMessage.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.darkGray))
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            Text(recentMessage.timeAgo)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(.label))
                        }
                    }

                    Divider()
                        .padding(.vertical, 8)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 50)
        }
    }
    
    private var newMessageButton: some View {
        Button {
            shouldShowNewMessageScreen.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color.blue)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
            CreateNewMessageView() { user in
                shouldNavigateToChatLogView.toggle()
                chatUser = user
                self.chatLogViewModel.chatUser = user
                self.chatLogViewModel.fetchMessages()
            }
        }
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
            .preferredColorScheme(.dark)
        
        MainMessagesView()
    }
}
