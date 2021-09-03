//
//  Customer.swift
//  CupcakeCorner
//
//  Created by 陶涛 on 2021/9/3.
//

import Foundation

class Customer: ObservableObject {
    @Published var order: Order
    
    init() {
        self.order = Order()
    }
}
