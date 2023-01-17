
import Foundation
import CoreLocation

public protocol LocationSearchViewModelDelegate:AnyObject{
    func didSelectLocation(at location:CLLocation, locationName:String)
    func didFinishSelectingAddress()
}

public class LocationSearchViewModel{
    
    private var placesManger:PlacesMangerProtocol
    public weak var delegate:LocationSearchViewModelDelegate?
    public init(){
        self.placesManger = PlacesManger()
    }
    
    public func search(for query:String, complition:@escaping(Result<[Place], Error>)->Void){
        placesManger.findPlaces(with: query) { result in
            complition(result)
        }
    }
    
    public func didSelectLocation(at location:CLLocation, locationName:String){
        self.delegate?.didSelectLocation(at: location, locationName: locationName)
        self.didFinishSelectingAddress()
    }
    
    public func didFinishSelectingAddress(){
        delegate?.didFinishSelectingAddress()
    }
    
    public func getLocationAddressName(for location:CLLocation, complition:@escaping(Result<String, Error>)->Void){
        placesManger.reverseLocationGecoder(for: location) { result in
            complition(result)
        }
    }
}
