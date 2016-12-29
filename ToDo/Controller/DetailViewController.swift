//
//  DetailViewController.swift
//  ToDo
//
//  Created by g tokman on 12/23/16.
//  Copyright © 2016 garytokman. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    var itemInfo: (itemManager: ItemManager, index: Int)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let itemInfo = itemInfo else { return }
        let item = itemInfo.itemManager.item(at: itemInfo.index)
        
        titleLabel.text = item.title
        locationNameLabel.text = item.location?.name
        descriptionLabel.text = item.itemDescription
        
        if let timestamp = item.timestamp {
            let date = Date(timeIntervalSince1970: timestamp)
            dateLabel.text = dateFormatter.string(from: date)
        }
        
        if let coordinate = item.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100)
            mapView.region = region
        }
        
    }
    
    @IBAction func checkItem() {
        if let itemInfo = itemInfo {
            itemInfo.itemManager.checkItem(at: itemInfo.index)
        }
    }

}
