//
//  ContentView.swift
//  iExpense
//
//  Created by 陶涛 on 2021/8/12.
//

import SwiftUI



struct ContentView: View {
    
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        if item.amount > 100 {
                            Text("$\(item.amount)")
                                .foregroundColor(.blue)
                        } else if item.amount > 10 {
                            Text("$\(item.amount)")
                                .foregroundColor(.red)
                        } else {
                            Text("$\(item.amount)")
                                .foregroundColor(.green)
                        }
                        
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.showingAddExpense = true
            }, label: {
                Image(systemName: "plus")
            }))
            
        }
        .sheet(isPresented: $showingAddExpense, content: {
            AddView(expenses: self.expenses)
        })
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
