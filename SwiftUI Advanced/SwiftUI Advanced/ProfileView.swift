//
//  ProfileView.swift
//  SwiftUI Advanced
//
//  Created by Stanly Shiyanovskiy on 06.07.2022.
//

import CoreData
import FirebaseAuth
import SwiftUI

struct ProfileView: View {
    
    @State
    private var showLoader = false
    
    @State
    private var showAlertView: Bool = false
    @State
    private var alertTitle: String = ""
    @State
    private var alertMessage: String = ""
    
    @State
    private var showSettingsView: Bool = false
    
    @Environment(\.presentationMode)
    var presentationMode
    
    @Environment(\.managedObjectContext)
    private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.userSince, ascending: true)], predicate: NSPredicate(format: "userID == %@", Auth.auth().currentUser!.uid), animation: .default)
    private var savedAccounts: FetchedResults<Account>
    
    @State
    private var currentAccount: Account?
    
    @State
    private var updater: Bool = true
    
    var body: some View {
        ZStack {
            Image("background-2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {
                        
                        if let imageData = currentAccount?.profileImage {
                            GradientProfilePictureView(profilePicture: UIImage(data: imageData)!)
                                .frame(width: 66, height: 66)
                        } else {
                            ZStack {
                                Circle()
                                    .foregroundColor(Color("pink-gradient-1"))
                                    .frame(width: 66, height: 66, alignment: .center)
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .medium, design: .rounded))
                            }
                            .frame(width: 66, height: 66, alignment: .center)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(currentAccount?.name ?? "No name")
                                .foregroundColor(.white)
                                .font(.title2)
                                .bold()
                            Text("View profile")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.footnote)
                        }
                        
                        Spacer()
                        
                        Button {
                            showSettingsView = true
                        } label: {
                            TextFieldIcon(iconName: "gearshape.fill", currentlyEditing: .constant(true), passedImage: .constant(nil))
                        }
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    Text(currentAccount?.bio ?? "No bio")
                        .foregroundColor(.white)
                        .font(.title2.bold())
                    
                    if currentAccount?.numberOfCertificates != 0 {
                        Label("Awarded \(currentAccount?.numberOfCertificates ?? 0) certificates since \(currentAccount?.userSince ?? Date())", systemImage: "calendar")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.footnote)
                    } else {
                        
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    HStack(spacing: 16) {
                        if currentAccount?.twitterHandle != nil {
                            Image("Twitter")
                                .resizable()
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 24, height: 24, alignment: .center)
                        }
                        
                        if let website = currentAccount?.website {
                            Image(systemName: "link")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                            Text(website)
                                .foregroundColor(.white.opacity(0.7))
                                .font(.footnote)
                        }
                    }
                }
                .padding(16)
                
                GradientButton(buttonTitle: "Purchase Lifetime Pro Plan") {
                    showLoader = true
                }
                .padding(.horizontal, 16)
                
                Button {
                    
                } label: {
                    GradientText(text: "Restore purchases")
                        .font(.footnote.bold())
                }
                .padding(.bottom)
            }
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.2))
                    .background(Color("secondaryBackground"))
                    .opacity(0.5)
                    .background(VisualEffectBlur(blurStyle: .dark))
                    .shadow(color: Color("shadowColor").opacity(0.5), radius: 60, x: 0, y: 30)
            )
            .cornerRadius(30)
            .padding(.horizontal)
            
            VStack {
                Spacer()
                
                Button {
                    signout()
                } label: {
                    Image(systemName: "arrow.turn.up.forward.iphone.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .rotation3DEffect(
                            Angle(degrees: 180),
                            axis: (x: 0, y: 0, z: 0)
                        )
                        .background(
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                .frame(width: 42, height: 42, alignment: .center)
                                .overlay(
                                    VisualEffectBlur(blurStyle: .dark)
                                        .cornerRadius(21)
                                        .frame(width: 42, height: 42, alignment: .center)
                                )
                        )
                }
            }
            .padding(.bottom, 64)
            
            if showLoader {
                ProgressView()
                    .progressViewStyle(
                        CircularProgressViewStyle()
                    )
            }
        }
        .colorScheme(updater ? .dark : .dark)
        .alert(isPresented: $showAlertView) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .cancel())
        }
        .sheet(isPresented: $showSettingsView) {
            SettingsView()
                .environment(\.managedObjectContext, viewContext)
                .onDisappear() {
                    currentAccount = savedAccounts.first!
                    updater.toggle()
                }
        }
        .onAppear() {
            currentAccount = savedAccounts.first
            
            if currentAccount == nil {
                let userDataToSave = Account(context: viewContext)
                userDataToSave.name = Auth.auth().currentUser!.displayName
                userDataToSave.bio = nil
                userDataToSave.userID = Auth.auth().currentUser!.uid
                userDataToSave.numberOfCertificates = 0
                userDataToSave.proMember = false
                userDataToSave.twitterHandle = nil
                userDataToSave.website = nil
                userDataToSave.profileImage = nil
                userDataToSave.userSince = Date()
                
                do {
                    try viewContext.save()
                } catch let error {
                    alertTitle = "Could not create an account"
                    alertMessage = error.localizedDescription
                    showAlertView.toggle()
                }
            }
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
            presentationMode.wrappedValue.dismiss()
        } catch let error {
            alertTitle = "Uh-oh!"
            alertMessage = error.localizedDescription
            showAlertView.toggle()
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
