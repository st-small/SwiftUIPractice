//
//  CartManager.swift
//  SweaterShopDemo
//
//  Created by Stanly Shiyanovskiy on 15.08.2022.
//

import Foundation

final class CartManager: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var total: Int = 0
    @Published var paymentSuccess = false
    
    let paymentHandler = PaymentHandler()
    
    func addToCart(product: Product) {
        products.append(product)
        total += product.price
    }
    
    func removeFromCart(product: Product) {
        products = products.filter { $0.id != product.id }
        total -= product.price
    }
    
    func pay() {
        paymentHandler.startPayment(products: products, total: total) { success in
            self.paymentSuccess = success
            self.products = []
            self.total = 0
        }
    }
}
