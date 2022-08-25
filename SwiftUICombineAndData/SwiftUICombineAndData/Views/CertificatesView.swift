//
//  CertificatesView.swift
//  SwiftUICombineAndData
//
//  Created by Stanly Shiyanovskiy on 22.08.2022.
//

import SwiftUI

struct CertificatesView: View {
    
    @StateObject var certificateVM = CertificateViewModel()
    @StateObject var networkReachability = NetworkReachability()
    @State private var selection: Int = 0
    
    var body: some View {
        VStack {
            if networkReachability.reachable {
                if certificateVM.certificates.isEmpty {
                    ProgressView()
                } else {
                    TabView(selection: $selection) {
                        ForEach(certificateVM.certificates.indices) { index in
                            CertificateCard(selection: $selection)
                                .padding(.horizontal, 8)
                                .environmentObject(certificateVM)
                        }
                    }
                    .tabViewStyle(.page)
                }
            } else {
                Text("Please connect to the Internet to see your certificates")
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .background(
            AccountBackground()
        )
    }
}

struct CertificatesView_Previews: PreviewProvider {
    static var previews: some View {
        CertificatesView()
    }
}
