//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by 陶涛 on 2021/9/1.
//

import SwiftUI

struct CheckoutView: View {
    
    @ObservedObject var customer: Customer

    @State private var confirmationMessage = ""
    @State private var confirmationTitle = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        GeometryReader(content: { geometry in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                    
                    Text("Your total is $\(customer.order.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place Order") {
                        placeOrder()
                    }
                    .padding()
                }
            }
        })
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showingConfirmation, content: {
            Alert(title: Text(confirmationTitle), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
        })
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(customer.order) else {
            print("Failed to encode order")
            return
        }
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.httpBody = encoded
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            showingConfirmation = true
            guard let data = data else {
                confirmationTitle = "Sorry"
                confirmationMessage = error?.localizedDescription ?? "Unknown error"
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                
            } else {
                confirmationTitle = "Sorry"
                confirmationMessage = "Invalid response from server"
            }
            
            
            
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(customer: Customer())
    }
}
