//
//  CustomTableViewCell.swift
//  testWeather
//
//  Created by Anton Asetski on 1/5/20.
//  Copyright © 2020 Anton Asetski. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var tempMin: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .none
    }
}
