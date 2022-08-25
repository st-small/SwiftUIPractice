//
//  ContentView.swift
//  SwiftUICombineAndData
//
//  Created by Stanly Shiyanovskiy on 16.08.2022.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var contentOffset = CGFloat(0)
    @State private var showCertificates = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                
                TrackableScrollView { offset in
                    contentOffset = offset.y
                    print("contentOffset", contentOffset)
                } content: {
                    content
                }
                
                VisualEffectBlur(blurStyle: .systemMaterial)
                    .opacity(contentOffset < -16 ? 1 : 0)
                    .animation(.easeIn, value: contentOffset)
                    .ignoresSafeArea()
                    .frame(height: 0)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(
                AccountBackground()
            )
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
        .accentColor(colorScheme == .dark ? .white : .purple)
    }
    
    var content: some View {
        VStack {
            
            ProfileRow()
                .onTapGesture {
                    showCertificates.toggle()
                }
            
            VStack {
                NotificationsRow()
                
                divider
                
                LiteModeRow()
            }
            .blurBackground()
            .padding(.top, 20)
            
            VStack {
                NavigationLink {
                    FAQView()
                } label: {
                    MenuRow()
                }

                divider
                
                NavigationLink {
                    PackagesView()
                } label: {
                    MenuRow(
                        title: "SwiftUI Packages",
                        leftIcon: "square.stack.3d.up.fill")
                }
                
                divider
                
                Link(destination: URL(string: "https://apple.com")!) {
                    MenuRow(
                        title: "YouTube Channel",
                        leftIcon: "play.rectangle.fill",
                        rightIcon: "link")
                }
            }
            .blurBackground()
            .padding(.top, 20)
            
            Text("Version 1.00")
                .foregroundColor(.white.opacity(0.7))
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                .font(.footnote)
        }
        .foregroundColor(.white)
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .sheet(isPresented: $showCertificates) {
            CertificatesView()
        }
    }
    
    var divider: some View {
        Divider()
            .background(
                Color.white.blendMode(.overlay)
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
