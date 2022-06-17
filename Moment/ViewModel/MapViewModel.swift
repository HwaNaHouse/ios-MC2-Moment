//
//  MapViewModel.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/08.
//

import SwiftUI
import MapKit

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    
    @Published var isFirstShow: Bool = true //edit 후에도 본인 위치로 가는 것을 방지.
    
    @Published var canMove: Bool = true //본인 위치 자연스럽게 이동.
    
    @Published var isEdited: Bool = false //edit중이었어서 카테고리 이동할 때는 firstPin함수 호출안되도록.
    
    var locationManager: CLLocationManager?
    
    //MARK: Authorization-related Methods
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager = CLLocationManager()
            
            locationManager!.delegate = self
            
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            
//            locationManager!.allowsBackgroundLocationUpdates = true //항상허용과 관련된 background logic
            
        } else {
            print("위치 서비스 기능을 On으로 변경 후 다시 접속해주십시오.")
        }
    }
    
    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        
        guard let locationManager = locationManager else { return }
        
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            print("Your location is restricted likely due to parental controls.")
            
        case .denied:
            print("You have denied this app location permissions. Go into settings to change it")
            
        case .authorizedWhenInUse, .authorizedAlways:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MapDetails.defaultSpan)
            
            locationManager.startUpdatingLocation()
            
            
//            locationManager.requestAlwaysAuthorization() //항상 허용 관련 로직.
            
//        case .authorizedAlways: //항상허용관련
//            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MapDetails.defaultSpan)
            
//            locationManager.startUpdatingLocation()
            
        @unknown default:
            break
        }
    }
    
    
    //MARK: Location-related Methods
    
    //user location...
    func myPosition() {
        guard let locationManager = locationManager else { return }
        
        withAnimation {
            canMove = false
            region = MKCoordinateRegion(
                center: locationManager.location!.coordinate,
                span: region.span.longitudeDelta < MapDetails.defaultSpan.longitudeDelta ? region.span : MapDetails.defaultSpan
            )
            canMove = true
        }
    }
    
    //first pin's location in category...
    func firstPinLocation(_ category: Category) {
        let arr: [Pin] = category.pinArray
        let firstPin: Bool = !arr.isEmpty
        
        if firstPin {
            withAnimation {
                region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: arr.first!.latitude, longitude: arr.first!.longtitude),
                    span: MapDetails.defaultSpan
                )
            }
        } else { self.myPosition() }
    }
    
    //pin's location...
    func pinLocation(_ pin: Pin) {
        withAnimation {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longtitude),
                span: region.span.longitudeDelta < MapDetails.defaultSpan.longitudeDelta ? region.span : MapDetails.defaultSpan
            )
        }
    }
}


enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 33.465256, longitude: 126.934102)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
}
