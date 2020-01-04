//
//  NetworkService.swift
//  testWeather
//
//  Created by Anton Asetski on 1/4/20.
//  Copyright © 2020 Anton Asetski. All rights reserved.
//

import Foundation

protocol NetworkDelegate: class {
    func didReceiveData(_ data:Welcome)
}

class Networker {
    
    weak var delegate: NetworkDelegate?
    
    func sentRequest(latitude: Double, longitude: Double) {
        let API_KEY = "c42721f2ac1674948d866a6ab30c8cba"
        let url = URL(string: "https://api.darksky.net/forecast/\(API_KEY)/\(latitude),\(longitude)/?exclude=minutely,hourly,alerts,flags&units=si")!
        let session = URLSession.shared
        let decoder = JSONDecoder()
        session.dataTask(with: url) { (data, _ , error) in
            guard let data = data else { return }
            do {
                let resp = try decoder.decode(Welcome.self, from: data)
                self.delegate?.didReceiveData(resp)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
