//
//  ContentView.swift
//  BucketList
//
//  Created by Monty Harper on 5/13/24.
//

import LocalAuthentication
import MapKit
import _MapKit_SwiftUI
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.1, longitude: -97.05),
        span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
    ))
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            NavigationStack {
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) {location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }
                    .mapStyle(viewModel.mapStyles[viewModel.mapStyle])
                    .toolbar {
                        Picker("Type:", selection: $viewModel.mapStyle) {
                            ForEach(0..<3) {index in
                                switch index {
                                case 0:
                                    Text("Hybrid").tag(0)
                                case 1:
                                    Text("Imagery").tag(1)
                                case 2:
                                    Text("Standard").tag(2)
                                default:
                                    Text("Standard").tag(2)
                                }
                            }
                        }
                    }
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) {
                            viewModel.update(location: $0)
                        }
                    }
                }
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
                .alert("Authentication Error", isPresented: $viewModel.isShowingAuthenticationAlert) {
                    Text(viewModel.authenticationAlertMessage)
                    Button("Okay", role: .cancel){}
                }
        }
    }
}

#Preview {
    ContentView()
}
