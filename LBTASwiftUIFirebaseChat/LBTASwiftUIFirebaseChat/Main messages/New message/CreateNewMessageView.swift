//
//  CreateNewMessageView.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Stanly Shiyanovskiy on 12.07.2022.
//

import SDWebImageSwiftUI
import SwiftUI

final class CreateNewMessageViewModel: ObservableObject {
    
    @Published var users: [ChatUser] = []
    @Published var errorMessage: String = ""
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { [weak self] documentsSnapshot, error in
                if let error = error {
                    self?.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                
                documentsSnapshot?.documents.forEach { snapshot in
                    let data = snapshot.data()
                    let user = ChatUser(data: data)
                    if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        self?.users.append(.init(data: data))
                    }
                }
            }
    }
}

struct CreateNewMessageView: View {
    
    let didSelectNewUser: (ChatUser) -> Void
    
    @Environment(\.presentationMode)
    var presentationMode
    
    @ObservedObject var vm = CreateNewMessageViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(vm.errorMessage)
                
                ForEach(vm.users) { user in
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                    } label: {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(.label), lineWidth: 1)
                                )
                            
                            Text(user.email)
                                .foregroundColor(Color(.label))
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("New Message")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewMessageView(didSelectNewUser: { _ in })
    }
}
