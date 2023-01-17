
import Foundation
import CoreLocation

public class LocationManger:NSObject, CLLocationManagerDelegate{
    private var locationManager:CLLocationManager!
    
    private override init(){
        
    }
    
    public static var shared = LocationManger()
    
    public func getCurrentLocationForUser()->CLLocation?{
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
        }
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        guard let location = locationManager.location else {return nil}
        
        return CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("LocationDelegate:")
        print(locations)
    }
}
