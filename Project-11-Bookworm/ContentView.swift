//
//  ContentView.swift
//  BookWorm
//
//  Created by Mehmet Atabey on 21.07.2021.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true)
        
    ]) var books: FetchedResults<Book>
    @State private var showingAddScreen = false
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books, id:\.self) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            HStack(alignment: .bottom) {
                                VStack(alignment: .leading) {
                                    Text(book.title ?? "Unknown title")
                                        .font(.headline)
                                        .foregroundColor(book.rating == 1 ? .red : .black)
                                    Text(book.author ?? "Unknown Author")
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("Date added: \(formatDate(date: book.date ?? Date()))")
                                    .font(.caption)
                            }
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    self.deleteBooks(at: indexSet)
                })
            }
            .navigationBarTitle("Book Worm")
            .navigationBarItems(leading: EditButton(),
                                trailing: Button(action: {
                                    self.showingAddScreen.toggle()
                                }) {
                                    Image(systemName: "plus")
                                }
            )
        }
        .sheet(isPresented: $showingAddScreen) {
            AddBookView().environment(\.managedObjectContext, self.moc)
        }
    }
    func deleteBooks(at offests: IndexSet) {
        for offset in offests {
            let book = books[offset]
            moc.delete(book)
        }
        
        try? moc.save()
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
