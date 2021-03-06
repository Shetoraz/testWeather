//
//  MainModel.swift
//  testWeather
//
//  Created by Anton Asetski on 2/10/20.
//  Copyright © 2020 Anton Asetski. All rights reserved.
//

import Foundation

class Model {

    var hourWeather = [Int]()

    func getHourlyWeather(data: Welcome) {
        for hour in data.hourly.data {
            self.hourWeather.append(Int(hour.temperature))
        }
    }
}
