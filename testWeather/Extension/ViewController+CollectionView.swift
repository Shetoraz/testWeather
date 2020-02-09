//
//  ViewController+CollectionView.swift
//  testWeather
//
//  Created by Anton Asetski on 1/6/20.
//  Copyright © 2020 Anton Asetski. All rights reserved.
//

import UIKit

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upCell", for: indexPath) as! CustomCollectionViewCell
        cell.tempLabel.text = "10"
        cell.timeLabel.text = "2 PM"
        
        return cell
    }
}
