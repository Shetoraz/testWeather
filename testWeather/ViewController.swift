import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var cityLabel: UILabel!
    
    
    let API_KEY = "c42721f2ac1674948d866a6ab30c8cba"
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        print("Longitude: \(userLocation!.coordinate.longitude)")
        print("Latitude: \(userLocation!.coordinate.latitude)")
        getWeather(for: ((userLocation!.coordinate.latitude), (userLocation!.coordinate.longitude)))
    }
    
    struct Response: Codable {
        var timezone: String?
        struct Daily: Codable {
            var moonPhase: Double
        }
         var data: [Daily]
    }
    
    
    func getWeather(for coordinates: (latitude: Double, longitude: Double)) {
        let latitude = userLocation?.coordinate.latitude ?? 0.0
        let longitude = userLocation?.coordinate.longitude ?? 0.0
        let session = URLSession.shared
        let url = URL(string: "https://api.darksky.net/forecast/\(API_KEY)/\(longitude),\(latitude)/?exclude=minutely,hourly,alerts,flags")!
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil { print(error); return }
            let decoder = JSONDecoder()
            print(url)
            do {
                let resp = try decoder.decode(Response.self, from: data!)
                DispatchQueue.main.async {
                     self.cityLabel.text =  resp.timezone ?? "Unknown"
                    print(resp.data[0].moonPhase)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}


