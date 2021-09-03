//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by 陶涛 on 2021/8/30.
//

import SwiftUI



struct ContentView: View {
    @ObservedObject var customer = Customer()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $customer.order.type) {
                        ForEach(0 ..< Order.types.count) { idx in
                            Text(Order.types[idx])
                        }
                    }
                    
                    Stepper(value: $customer.order.quantity, in: 3 ... 20) {
                        Text("Number of cakes: \(customer.order.quantity)")
                    }
                }
                
                Section {
                    Toggle(isOn: $customer.order.specialRequestEnabled.animation(), label: {
                        Text("Any special requests?")
                    })
                    
                    if customer.order.specialRequestEnabled {
                        Toggle(isOn: $customer.order.extraFrosting, label: {
                            Text("Add extra frosting")
                        })
                        Toggle(isOn: $customer.order.addSprinkles, label: {
                            Text("Add extra sprinkles")
                        })
                    }
                }
                
                Section {
                    NavigationLink(
                        destination: AddressView(customer: customer),
                        label: {
                            Text("Delivery details")
                        })
                }
            }
            .navigationTitle("Cupcake Corner")
        }
        // 解决控制台报错：displayModeButtonItem is internally managed and not exposed for DoubleColumn style
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
