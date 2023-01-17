
import Foundation
import MapKit
import CoreLocation

public protocol ResultViewControllerDelegate:AnyObject{
    func didTapPlace(with coordinates:CLLocationCoordinate2D)
}
public class ResultViewController:UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    public weak var delegate:ResultViewControllerDelegate?
    private var places:[Place] = []

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)
        
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    public func update(with places:[Place]){
        self.tableView.isHidden = false
        self.places = places
        self.tableView.reloadData()
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true
        let place = places[indexPath.row]
        
        getLocationCoordinates(place: place){
            [weak self] (resul) in
            
            switch resul{
            case .success(let coordinates):
                DispatchQueue.main.async {
                    self?.delegate?.didTapPlace(with: coordinates)
                }
                
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
            }
        }
    }
        public func getLocationCoordinates(place:Place, completion:@escaping(Result<CLLocationCoordinate2D, Error>)->Void){
            guard let location = place.location else
                {
                    if #available(iOS 13.0, *) {
//                        completion(.failure(AppError.unknownError))
                                   } else {
                            // Fallback on earlier versions
                        }
                    return
                }
                completion(.success(location.coordinate))
        }
}
