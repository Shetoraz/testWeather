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
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!

    private let locationManager = LocationService.shared
    private let networker = Networker()
    private let model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.networker.delegate = self        
    }
    
    func onLocationUpdate(location: CLLocation) {
        self.networker.sentRequest(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
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
            self.updateDate()
            self.updateImages()
        }
    }

    func updateImages() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 1...12:
            self.backgroundImage.image = #imageLiteral(resourceName: "background")
        case 12...24:
            self.backgroundImage.image = #imageLiteral(resourceName: "background")
        default:
            self.backgroundImage.image = #imageLiteral(resourceName: "background")
        }
    }
    
    func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        self.weekdayLabel.text = dateFormatter.string(from: Date())
        let hour = Calendar.current.component(.hour, from: Date())
        self.slider.value = Float(hour)
        switch hour {
        case 1...12: 
            self.timeLabel.text = String(Int(self.slider.value)) + " am"
        case 12...24:
            self.timeLabel.text = String(Int(self.slider.value)) + " pm"
        default:
            self.timeLabel.text = ""
        }
        self.slider.minimumValue = Float(hour)
    }
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        switch sender.value {
        case 1...12: 
            self.timeLabel.text = String(Int(sender.value)) + " am"
        case 12...24:
            self.timeLabel.text = String(Int(sender.value)) + " pm"
        default:
            self.timeLabel.text = ""
        }
        let position = sender.value - sender.minimumValue
        self.currentlyTemp.text = String(self.model.hourWeather[Int(position)])
    }
}

extension ViewController: NetworkDelegate {
    
    func didReceiveData(_ data: Welcome) {
        updateUI(city: data.timezone, status: data.currently.summary, currTemp: String(Int(data.currently.temperature)), maxTemp: String(Int(data.daily.data[0].temperatureMax)), minTemp: String(Int(data.daily.data[0].temperatureLow)))
        
        for hour in data.hourly.data {
            self.model.hourWeather.append(Int(hour.temperature))
        }
    }
}
