//
//  ContentView.swift
//  Milestone-projects-13-15
//
//  Created by Mehmet Atabey on 1.08.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var addingNewFriend = false
    @State private var persons = [Person]()
    var body: some View {
        return NavigationView {
            VStack {
                List {
                    ForEach(persons) {person in
                        HStack {
                            let image = loadImage(fileName: person.id)
                            image?
                                .resizable()
                                .frame(width: 30, height: 30)
                            NavigationLink(person.name, destination: PersonView(person: person))
                        }
                    }
                }
            }
            .sheet(isPresented: $addingNewFriend, onDismiss: loadData) {
                AddFriendView(persons: $persons)
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            .navigationBarTitle("Friember")
            .navigationBarItems(trailing: Button(action: {
                self.addingNewFriend = true
            }) {
                Image(systemName: "plus")
            })
        }
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        let url = FileManager.default.fileNameInDocumentsDirectory("users.json")
        
        do {
            let data = try Data(contentsOf: url)
            let decodedContent = try? JSONDecoder().decode([Person].self, from: data)
            if let persons = decodedContent {
                self.persons = persons.sorted()
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


