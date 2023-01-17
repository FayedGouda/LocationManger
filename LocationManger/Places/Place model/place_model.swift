
import CoreLocation

public struct Place{
    var name:String
    var id:String
    var location:CLLocation?
    
    public init(name: String, id: String, location: CLLocation) {
        self.name = name
        self.id = id
        self.location = location
    }
}
