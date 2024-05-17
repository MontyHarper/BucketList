//
//  EditViewViewModel.swift
//  BucketList
//
//  Created by Monty Harper on 5/17/24.
//

import Foundation

extension EditView {
    @Observable class ViewModel {
        
        private var location: Location

        var name: String
        var description: String
        var onSave: (Location) -> Void
        var loadingState = LoadingState.loading
        var pages = [Page]()
        
        init(location: Location, onSave: @escaping (Location) -> Void) {
            self.location = location
            self.name = location.name
            self.description = location.description
            self.onSave = onSave
        }
        
        func save() {
            var newLocation = location
            newLocation.id = UUID() // New id required so the UI will update
            newLocation.name = name
            newLocation.description = description
            onSave(newLocation)
        }
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            guard let url = URL(string: urlString) else {
                print("Bad url: ", urlString)
                return
            }
            print(urlString)
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                print("got data")
                let items = try JSONDecoder().decode(Result.self, from: data)
                print("JSON decoded")
                pages = items.query.pages.values.sorted()
                print("items retrieved: ", pages.count)
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
    }
}
