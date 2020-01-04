import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func onLocationUpdate(location: CLLocation)
    func onLocationDidFailWithError(error: Error)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationService()
    
    var delegate: LocationServiceDelegate?
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    private override init() {
        super.init()
        self.initializeLocationServices()
    }
    
    func initializeLocationServices() {
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = 50
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            self.locationManager.requestAlwaysAuthorization()
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("User choosed location when app is in use.")
        @unknown default:
            print("Unhandled error occured.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last!
        locationChanged(location: currentLocation)
    }
    
    private func locationChanged(location: CLLocation) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.onLocationUpdate(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager.stopUpdatingLocation()
        locationFailed(error: error)
    }
    
    private func locationFailed(error: Error) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.onLocationDidFailWithError(error: error)
    }
}
