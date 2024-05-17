//
//  EditView.swift
//  BucketList
//
//  Created by Monty Harper on 5/14/24.
//

import SwiftUI

struct EditView: View {
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @State private var viewModel: ViewModel
    
    @Environment(\.dismiss) var dismiss
        
    init(location: Location, onSave: @escaping (Location) -> Void) {
        viewModel = ViewModel(location: location, onSave: onSave)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name: ", text: $viewModel.name)
                    TextField("Description: ", text: $viewModel.description)
                }
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                        
                    case .loaded:
                        Text("Nearby Sites To See")
                        ForEach(viewModel.pages, id:\.pageid) {page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                        
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Location Details")
            .toolbar {
                Button("Save") {
                    viewModel.save()
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
}

#Preview {
    EditView(location: .example) {_ in}
}
