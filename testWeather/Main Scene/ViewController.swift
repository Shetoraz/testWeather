import UIKit
import CoreLocation

class ViewController: UIViewController, LocationServiceDelegate {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var currentlyTemp: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var slider: UILabel!
    
    private let locationManager = LocationService.shared
    private let networker = Networker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        networker.delegate = self 
    }
    
    func onLocationUpdate(location: CLLocation) {
        networker.sentRequest(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func onLocationDidFailWithError(error: Error) {
        print("Error!")
    }

    func updateUI(city: String, status: String, currTemp: String, maxTemp: String, minTemp: String) {
        DispatchQueue.main.async {
            self.cityLabel.text = city
            self.statusLabel.text = status
            self.currentlyTemp.text = currTemp + "°"
            self.maxTempLabel.text = maxTemp + "°"
            self.minTempLabel.text = minTemp + "°"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            self.weekdayLabel.text = dateFormatter.string(from: Date())
        }
    }
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        switch sender.value {
        case 1...12: 
            timeLabel.text = String(Int(sender.value)) + " am"
        case 12...24:
            timeLabel.text = String(Int(sender.value)) + " pm"
        default:
            timeLabel.text = ""
        }
    }
}

extension ViewController: NetworkDelegate {
    
    func didReceiveData(_ data: Welcome) {
        updateUI(city: data.timezone, status: data.currently.summary, currTemp: String(Int(data.currently.temperature)), maxTemp: String(Int(data.daily.data[0].temperatureMax)), minTemp: String(Int(data.daily.data[0].temperatureLow)))
    }
}
