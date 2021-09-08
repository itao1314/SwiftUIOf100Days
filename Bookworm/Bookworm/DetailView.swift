//
//  DetailView.swift
//  Bookworm
//
//  Created by 陶涛 on 2021/9/8.
//

import SwiftUI
import CoreData

struct DetailView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    let book: Book
    var body: some View {
        GeometryReader(content: { geometry in
            
            VStack {
                ZStack(alignment: .bottomTrailing, content: {
                    Image(book.genre ?? "Fantasy")
                        .frame(maxWidth: geometry.size.width)
                    Text(book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -8, y: -2)
                })
                
                Text(self.book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)
                Text(self.book.review ?? "No review")
                    .padding()
                RatingView(rating: .constant(Int(book.rating)))
                    .padding()
                Spacer()
            }
            
        })
        .navigationTitle(book.title ?? "Unknown Book")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            showingDeleteAlert = true
        }, label: {
            Image(systemName: "trash")
        }))
        .alert(isPresented: $showingDeleteAlert, content: {
            Alert(title: Text("Delete book"), message: Text("Are you sure"), primaryButton: .destructive(Text("Delete"), action: {
                deleteBook()
            }), secondaryButton: .cancel())
        })
    }
    
    func deleteBook() {
        moc.delete(book)
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it."
        return DetailView(book: book)
    }
}
