//
//  SettingsView.swift
//  SwiftUI Advanced
//
//  Created by Stanly Shiyanovskiy on 11.07.2022.
//

import CoreData
import FirebaseAuth
import SwiftUI

struct SettingsView: View {
    
    @State
    private var editingNameTextField = false
    @State
    private var editingTwitterTextField = false
    @State
    private var editingSiteTextField = false
    @State
    private var editingBioTextField = false
    
    @State
    private var nameIconBounce = false
    @State
    private var twitterIconBounce = false
    @State
    private var siteIconBounce = false
    @State
    private var bioIconBounce = false
    
    @State
    private var name = ""
    @State
    private var twitter = ""
    @State
    private var site = ""
    @State
    private var bio = ""
    
    @State
    private var showImagePicker = false
    @State
    private var inputImage: UIImage?
    
    @State
    private var showAlertView: Bool = false
    @State
    private var alertTitle: String = ""
    @State
    private var alertMessage: String = ""
    
    @Environment(\.managedObjectContext)
    private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.userSince, ascending: true)], predicate: NSPredicate(format: "userID == %@", Auth.auth().currentUser!.uid), animation: .default)
    private var savedAccounts: FetchedResults<Account>
    
    @State
    private var currentAccount: Account?
    
    private let generator = UISelectionFeedbackGenerator()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Settings")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                    .padding(.top)
                Text("Manage your Design+Code profile and account")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.callout)
                
                // Choose photo
                Button {
                    showImagePicker = true
                } label: {
                    HStack(spacing: 12) {
                        TextFieldIcon(iconName: "person.crop.circle", currentlyEditing: .constant(false), passedImage: $inputImage)
                        GradientText(text: "Choose Photo")
                        Spacer()
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .background(
                        Color(red: 26/255, green: 20/255, blue: 51/255)
                            .cornerRadius(16)
                    )
                }
                
                // Name TextField
                GradientTextField(editingTextField: $editingNameTextField, textFieldString: $name, iconBounce: $nameIconBounce, textFieldPlaceholder: "Name", textFieldIconString: "textformat.alt")
                    .autocapitalization(.words)
                    .textContentType(.name)
                    .disableAutocorrection(true)
                
                // Twitter Handle TextField
                GradientTextField(editingTextField: $editingTwitterTextField, textFieldString: $twitter, iconBounce: $twitterIconBounce, textFieldPlaceholder: "Twitter Handle", textFieldIconString: "at")
                    .autocapitalization(.none)
                    .keyboardType(.twitter)
                    .disableAutocorrection(true)
                
                // Site TextField
                GradientTextField(editingTextField: $editingSiteTextField, textFieldString: $site, iconBounce: $siteIconBounce, textFieldPlaceholder: "Website", textFieldIconString: "link")
                    .autocapitalization(.none)
                    .keyboardType(.webSearch)
                    .disableAutocorrection(true)
                
                // Bio TextField
                GradientTextField(editingTextField: $editingBioTextField, textFieldString: $bio, iconBounce: $bioIconBounce, textFieldPlaceholder: "Bio", textFieldIconString: "text.justifyleft")
                    .autocapitalization(.sentences)
                    .keyboardType(.default)
                
                GradientButton(buttonTitle: "Save Settings") {
                    generator.selectionChanged()
                    
                    currentAccount?.name = name
                    currentAccount?.bio = bio
                    currentAccount?.twitterHandle = twitter
                    currentAccount?.website = site
                    currentAccount?.profileImage = inputImage?.pngData()
                    
                    do {
                        try viewContext.save()
                        
                        alertTitle = "Settings saved!"
                        alertMessage = "Your changes have been saved"
                        showAlertView.toggle()
                    } catch let error {
                        alertTitle = "Uh-oh!"
                        alertMessage = error.localizedDescription
                        showAlertView.toggle()
                    }
                }
                
                Spacer()
            }
            .padding()
            
            Spacer()
        }
        .background(
            Color("settingsBackground")
                .edgesIgnoringSafeArea(.all)
        )
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .onAppear() {
            currentAccount = savedAccounts.first
            
            name = currentAccount?.name ?? ""
            bio = currentAccount?.bio ?? ""
            twitter = currentAccount?.twitterHandle ?? ""
            site = currentAccount?.website ?? ""
            inputImage = UIImage(data: currentAccount?.profileImage ?? Data())
        }
        .alert(isPresented: $showAlertView) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .cancel())
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
