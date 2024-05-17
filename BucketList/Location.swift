//
//  Location.swift
//  BucketList
//
//  Created by Monty Harper on 5/13/24.
//

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable {
    
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    #if DEBUG
    static let example = Location(id: UUID(), name: "Stillwater, OK", description: "My hometown", latitude: 39.1, longitude: -97.05)
    #endif
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
