//
//  HomeView.swift
//  InstagramDemo
//
//  Created by Stanly Shiyanovskiy on 13.08.2022.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            Header()
            
            ScrollView(.vertical, showsIndicators: false) {
                Stories()
                Divider()
                Post()
                Post(image: "dog", description: "Almost 2 years old, I love her.")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
