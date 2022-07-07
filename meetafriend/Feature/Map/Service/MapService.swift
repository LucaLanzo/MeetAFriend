//
//  MapService.swift
//  meetafriend
//
//  Created by Luca on 13.06.22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


protocol MapService {
    var mapViewModel: MapViewModel { get }
    var closeTo: [String] { get }
    var listenStarted: Bool { get }
}

final class MapServiceImpl: ObservableObject, MapService {
    @Published var mapViewModel = MapViewModel()
    @Published var closeTo: [String] = []
    @Published var listenStarted: Bool = false
    
    private var locations: [Location] = []
    
    private let updateInterval = 5.0
    private weak var timer: Timer?
    
    private let db = Firestore.firestore()
    
    init() {
        mapViewModel.checkIfLocationServicesIsEnabled()
    }
}

extension MapServiceImpl {
    func getCoordinates() {
        db.collection("locations").addSnapshotListener() { querySnapshot, err in
            querySnapshot?.documentChanges.forEach{ change in
                switch(change.type) {
                case .modified:
                    do {
                        let changedLocation = try change.document.data(as: Location.self)
                        
                        if let locationIndex = self.locations.firstIndex(where: { $0.id ==
                            change.document.documentID}) {
                            self.locations[locationIndex] = changedLocation
                        }
                        
                    } catch {
                        print(error)
                    }
                    
                case .added:
                    do {
                        let newLocation = try change.document.data(as: Location.self)
                        
                        self.locations.append(newLocation)
                        
                    } catch {
                        print(error)
                    }
                
                case .removed:
                    print("\(change.document.data()["name"] ?? "Nothing") has been deleted.")
                }
            }
        }
        listenToVicinity()
        self.listenStarted = true
    }
    
    func startDemoMode() {
        print("Starting demo mode, stop timer, add all locations close to")
        
        self.timer?.invalidate()
        self.closeTo.removeAll()
        
        for loc in self.locations {
            self.closeTo.append(loc.id!)
        }
    }
    
    func stopDemoMode() {
        print("Stopping demo mode, remove all close to, start listen")
        
        self.closeTo.removeAll()
        
        self.listenToVicinity()
    }
}

private extension MapServiceImpl {
    
    func listenToVicinity() {
        timer?.invalidate()   // just in case there is existing `Timer`, `invalidate` it before we lose our reference to it
        
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            if (self!.locations.count != 0) {
                for loc in self!.locations {
                    if (self!.mapViewModel.locationManager!.location == nil) { continue }
                    
                    let lat1 = loc.coordinates.latitude
                    let lat2 = self!.mapViewModel.locationManager!.location!.coordinate.latitude
                    
                    let lon1 = loc.coordinates.longitude
                    let lon2 = self!.mapViewModel.locationManager!.location!.coordinate.longitude
                    
                    let distanceToLocation = self!.distanceToLocation(lat1: lat1, lon1: lon1, lat2: lat2, lon2: lon2)
                    
                    if (distanceToLocation < 100.0) {
                        if !self!.closeTo.contains(where: { $0 == loc.id }) {
                            self!.closeTo.append(loc.id!)
                        }
                    } else {
                        if let index = self!.closeTo.firstIndex(where: { $0 == loc.id }) {
                            self!.closeTo.remove(at: index)
                        }
                    }
                }
                
                print("closeTo:")
                self!.closeTo.forEach({ loc in
                    print(loc)
                })
            } else {
                print("MapService: No locations found")
            }
        }
    }
    
    func degreesToRadians(degrees: Double) -> Double {
        return degrees * Double.pi / 180
    }
    
    func distanceToLocation(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let earthRadiusKm = 6371.0

        let dLat = degreesToRadians(degrees: lat1 - lat2)
        let dLon = degreesToRadians(degrees: lon1 - lon2)
        
        let lat1 = degreesToRadians(degrees: lat1)
        let lat2 = degreesToRadians(degrees: lat2)

        let a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2);
        let c = 2 * atan2(sqrt(a), sqrt(1-a));
        
        return earthRadiusKm * c * 1000.0
    }
}


