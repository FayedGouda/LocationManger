
import UIKit
import MapKit
import CoreLocation

public class LocationSearchVC: UIViewController, UISearchResultsUpdating  {
      
    var fullAddress = ""
    var currentLocation:CLLocation?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationInfo:UILabel!
    public var viewModel:LocationSearchViewModel!
    let searchVC = UISearchController(searchResultsController: ResultViewController())
    public override func viewDidLoad() {
        super.viewDidLoad()
        zoomToCurrentLocation()
    }
    
   public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchVC.searchResultsUpdater = self
        searchVC.searchBar.backgroundColor = .white
        navigationItem.searchController = searchVC
    }
    
    @IBAction func userDidSelectAddress(_ sender: UIButton) {
        guard let currentLocation = currentLocation else {
            viewModel.didFinishSelectingAddress()
            return
        }
        self.viewModel.didSelectLocation(at: currentLocation, locationName: self.fullAddress)
    }
    
    private func zoomToCurrentLocation(){
        guard let currentUserLocation = LocationManger.shared.getCurrentLocationForUser() else {return}
       
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let coordinates = CLLocationCoordinate2D(latitude: currentUserLocation.coordinate.latitude, longitude: currentUserLocation.coordinate.longitude)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span:span), animated: true)
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultsVC = searchController.searchResultsController as? ResultViewController
        else{
            return
        }
        resultsVC.delegate = self
        viewModel.search(for: query){ result in
            switch result {
            case .success(let places):
                DispatchQueue.main.async {
                    resultsVC.update(with:places)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
extension LocationSearchVC:MKMapViewDelegate{
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationInfo.text = "Loading..."
        
        let newLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        self.viewModel.getLocationAddressName(for: newLocation) { [weak self] result in
            switch result{
            case .success(let address):
                self?.locationInfo.text = address
                self?.currentLocation = newLocation
                self?.fullAddress = address
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension LocationSearchVC:ResultViewControllerDelegate{
    public func didTapPlace(with coordinates: CLLocationCoordinate2D) {
        searchVC.searchBar.resignFirstResponder()
        searchVC.dismiss(animated: true, completion: nil)
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span:span), animated: true)
    }
}
