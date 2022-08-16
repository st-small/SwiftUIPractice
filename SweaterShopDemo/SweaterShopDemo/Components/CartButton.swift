//
//  CartButton.swift
//  SweaterShopDemo
//
//  Created by Stanly Shiyanovskiy on 15.08.2022.
//

import SwiftUI

struct CartButton: View {
    
    let numberOfProducts: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: "cart")
                .padding(.top, 5)
            
            if numberOfProducts > 0 {
                Text("\(numberOfProducts)")
                    .font(.caption).bold()
                    .foregroundColor(.white)
                    .frame(width: 15, height: 15)
                    .background(
                        Color(hue: 1, saturation: 0.89, brightness: 0.835)
                    )
                    .cornerRadius(50)
            }
        }
    }
}

struct CartButton_Previews: PreviewProvider {
    static var previews: some View {
        CartButton(numberOfProducts: 1)
    }
}
