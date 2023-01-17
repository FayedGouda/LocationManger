
import Foundation
import CoreLocation
import MapKit

public protocol PlacesMangerProtocol:AnyObject{
    func reverseLocationGecoder(for location:CLLocation, completion:@escaping(Result<String, Error>)->Void)
    func findPlaces(with query:String, completion:@escaping(Result<[Place], Error>)->Void)
}

open class PlacesManger: PlacesMangerProtocol {
    private var geoCoder:CLGeocoder!
    public init(){
        geoCoder = CLGeocoder()
    }
    
    public func reverseLocationGecoder(for location:CLLocation, completion:@escaping(Result<String, Error>)->Void){
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            guard let places = placemarks, error == nil else {
                completion(.failure(error!))
                return
            }
            let placeMark = places[0]
            var fullAddress = ""
            // Country
            if let country = placeMark.country {
                fullAddress += country + ", "
            }
            // City
            if let city = placeMark.locality {
                fullAddress += city + ", "
            }
            // Street address
            if let street = placeMark.thoroughfare {
                fullAddress += street
            }
            
            completion(.success(fullAddress))
        })
    }
    
    public func findPlaces(with query:String, completion:@escaping(Result<[Place], Error>)->Void){
        
        geoCoder.geocodeAddressString(query) { results, error in
            guard let results = results, error == nil else{
                completion(.failure(error!))
                return
            }
            guard let newResult = results.first else {return}
            guard let location = newResult.location else {return}
            var fullName = ""
            if let name = newResult.country{
                fullName += name
            }
            if let city = newResult.locality{
                fullName += ", " + city
            }
            if let street = newResult.locality{
                fullName += ", " + street
            }
            let newPlaces:[Place] = results.compactMap({_ in
                
                Place(name: fullName, id: fullName, location: location)
                
            })
            completion(.success(newPlaces))
        }
    }
}
