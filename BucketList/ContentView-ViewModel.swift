//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Monty Harper on 5/17/24.
//

import CoreLocation
import Foundation
import LocalAuthentication
import MapKit
import _MapKit_SwiftUI

extension ContentView {
    @Observable class ViewModel {
        
        private(set) var locations: [Location]
        var selectedPlace: Location?
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        var isUnlocked = false
        var mapStyle = 2
        let mapStyles: [MapStyle] = [.hybrid, .imagery, .standard]
        var isShowingAuthenticationAlert: Bool = false
        var authenticationAlertMessage: String = ""
        
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to Save Data")
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New Location", description: "Description", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace else {return}
            if let index = locations.firstIndex(where: {$0 == selectedPlace}) {
                locations[index] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in

                    if success {
                        self.isUnlocked = true
                    } else {
                        self.authenticationAlertMessage = "Could Not Authenticate"
                        self.isShowingAuthenticationAlert = true
                    }
                }
            } else {
                authenticationAlertMessage = "None Shall Pass"
                self.isShowingAuthenticationAlert = true
            }
        }
    }
}
