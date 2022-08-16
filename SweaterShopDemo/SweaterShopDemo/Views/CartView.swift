//
//  CartView.swift
//  SweaterShopDemo
//
//  Created by Stanly Shiyanovskiy on 15.08.2022.
//

import SwiftUI

struct CartView: View {
    
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        ScrollView {
            if cartManager.paymentSuccess {
                Text("Thanks for your purchase! You'll get cozy in our comfy sweaters soon! You'll also receive an email confirmation shortly.")
                    .padding()
            } else {
                if cartManager.products.isEmpty {
                    Text("Your cart is empty")
                } else {
                    ForEach(cartManager.products, id: \.id) { product in
                        ProductRow(product: product)
                    }
                    
                    HStack {
                        Text("Your cart total is")
                        Spacer()
                        Text("$\(cartManager.total).00")
                            .bold()
                    }
                    .padding()
                    
                    PaymentButton(action: cartManager.pay)
                        .padding()
                }
            }
        }
        .navigationTitle("My Cart")
        .padding(.top)
        .onDisappear {
            if cartManager.paymentSuccess {
                cartManager.paymentSuccess = false
            }
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
            .environmentObject(CartManager())
    }
}
