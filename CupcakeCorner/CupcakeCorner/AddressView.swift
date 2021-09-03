//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by 陶涛 on 2021/9/1.
//

import SwiftUI

struct AddressView: View {
    
    @ObservedObject var customer: Customer
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $customer.order.name)
                TextField("Street Address", text: $customer.order.streetAddress)
                TextField("City", text: $customer.order.city)
                TextField("Zip", text: $customer.order.zip)
            }
            
            Section {
                NavigationLink(
                    destination: CheckoutView(customer: customer),
                    label: {
                        Text("Check out")
                    })
            }
            .disabled(customer.order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(customer: Customer())
    }
}
