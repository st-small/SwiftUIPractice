//
//  AccountView.swift
//  DesignCodeiOS15
//
//  Created by Stanly Shiyanovskiy on 20.07.2022.
//

import SwiftUI

struct AccountView: View {
    
    @State var isDeleted = false
    @State var isPinned = false
    @State var address: Address = Address(id: 1, country: "Canada")
    @Environment(\.dismiss) var dismiss
    @AppStorage("isLogged") var isLogged = false
    @AppStorage("isLiteMode") var isLiteMode = true
    
    var body: some View {
        NavigationView {
            List {
                
                profile
                
                menu
                
                Section {
                    Toggle(isOn: $isLiteMode) {
                        Label("Lite Mode", systemImage: isLiteMode ? "tortoise" : "hare")
                    }
                }
                .accentColor(.primary)
                
                links
                
                Button {
                    isLogged = false
                    dismiss()
                } label: {
                    Text("Sign out")
                }
                .tint(.red)
            }
            .task {
                await fetchAddress()
            }
            .refreshable {
                await fetchAddress()
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Account")
            .navigationBarItems(trailing: Button {
                dismiss()
            } label: {
                Text("Done").bold()
            })
        }
    }
    
    var profile: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.crop.circle.fill.badge.checkmark")
                .symbolVariant(.circle.fill)
                .font(.system(size: 32))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.blue, .blue.opacity(0.3))
                .padding()
                .background(Circle().fill(.ultraThinMaterial))
                .background(
                    HexagonView()
                        .offset(x: -50, y: -100)
                )
                .background(
                    BlobView()
                        .offset(x: 200, y: 0)
                        .scaleEffect(0.6)
                )
            Text("Meng To")
                .font(.title.weight(.semibold))
            HStack {
                Image(systemName: "location")
                    .imageScale(.large)
                Text(address.country)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    var menu: some View {
        Section {
            NavigationLink(destination: HomeView()) {
                Label("Settings", systemImage: "gear")
            }
            
            NavigationLink { Text("Billing") } label: {
                Label("Billing", systemImage: "creditcard")
            }
            
            NavigationLink { HomeView() } label: {
                Label("Help", systemImage: "questionmark")
            }
        }
        .accentColor(.primary)
        .listRowSeparatorTint(.red)
        .listRowSeparator(.hidden)
    }
    
    var links: some View {
        Section {
            if !isDeleted {
                Link(destination: URL(string: "https://apple.com")!) {
                    HStack {
                        Label("Website", systemImage: "house")
                        Spacer()
                        Image(systemName: "link")
                            .foregroundColor(.secondary)
                    }
                }
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button {
                        isDeleted.toggle()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                    
                    pinButton
                    
                }
            }
            Link(destination: URL(string: "https://youtube.com")!) {
                HStack {
                    Label("YouTube", systemImage: "tv")
                    Spacer()
                    Image(systemName: "link")
                        .foregroundColor(.secondary)
                }
            }
            .swipeActions {
                pinButton
            }
        }
        .accentColor(.primary)
        .listRowSeparator(.hidden)
    }
    
    var pinButton: some View {
        Button { isPinned.toggle() } label: {
            if isPinned {
                Label("Unpin", systemImage: "pin.slash")
            } else {
                Label("Pin", systemImage: "pin")
            }
        }
        .tint(isPinned ? .gray : .yellow)
    }
    
    func fetchAddress() async {
        do {
            let url = URL(string: "https://random-data-api.com/api/address/random_address")!
            let (data, _) = try await URLSession.shared.data(from: url)
            address = try JSONDecoder().decode(Address.self, from: data)
        } catch {
            address = Address(id: 1, country: "Error fetching")
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
