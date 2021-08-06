//
//  EditView.swift
//  BucketList
//
//  Created by Mehmet Atabey on 3.08.2021.
//

import SwiftUI
import MapKit

struct EditView: View {
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var placeMark : MKPointAnnotation
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $placeMark.wrappedTitle)
                    TextField("Description", text: $placeMark.wrappedSubtitle)
                }
                Section(header: Text("Nearby...")) {
                    if loadingState == .loaded {
                        List(pages, id:\.pageId) { page in
                            Text(page.title)
                                .font(.headline)
                                + Text(": ") +
                                Text(page.description)
                                    .italic()
                        }
                    }
                    else if (loadingState == .loading) {
                        Text("Loading...")
                    }
                    else {
                        Text("Please Try Again Later")
                    }
                }
            }
            .navigationBarTitle("Edit place")
            .navigationBarItems(trailing: Button("Done") {
                self.presentationMode.wrappedValue.dismiss()
            })
            .onAppear(perform: fetchByNearbyPlaces)
 
        }
    }
    func fetchByNearbyPlaces() {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(placeMark.coordinate.latitude)%7C\(placeMark.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

        print(urlString)
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) {data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                if let items = try? decoder.decode(Result.self, from: data) {
                    self.pages = Array(items.query.pages.values).sorted()
                    self.loadingState = .loaded
                    return
                }
            }
            self.loadingState = .failed
        }
        .resume()
    }
}


