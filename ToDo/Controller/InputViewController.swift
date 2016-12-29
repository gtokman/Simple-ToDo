//
//  InputViewController.swift
//  ToDo
//
//  Created by g tokman on 12/23/16.
//  Copyright © 2016 garytokman. All rights reserved.
//

import CoreLocation
import UIKit

class InputViewController: UIViewController {
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    lazy var geocoder = CLGeocoder()
    var itemManager: ItemManager?
    
    @IBAction func save() {
        
        guard let titleString = titleTextField.text,
            !titleString.isEmpty else {
                return
        }
        let date: Date?
        if let dateText = self.dateTextField.text,
            !dateText.isEmpty {
            date = dateFormatter.date(from: dateText)
        } else {
            date = nil
        }
        let descriptionString = descriptionTextField.text
        
        if let locationName = locationTextField.text {
            if let address = addressTextField.text,
                !address.isEmpty {
                
                
                geocoder.geocodeAddressString(address) {
                    [unowned self] (placeMarks, error) -> Void in
                    
                    
                    let placeMark = placeMarks?.first
                    
                    
                    let item = ToDoItem(
                        title: titleString,
                        itemDescription: descriptionString,
                        timestamp: date?.timeIntervalSince1970,
                        location: Location(
                            name: locationName,
                            coordinate: placeMark?.location?.coordinate))
                    
                    DispatchQueue.main.async {
                        self.itemManager?.add(item)
                        self.dismiss(animated: true)
                    }
                    
                }
            } else {
                let item = ToDoItem(title: titleString, itemDescription: descriptionString, timestamp: date?.timeIntervalSince1970, location: nil)
                self.itemManager?.add(item)
                dismiss(animated: true)
            }
        }
        
        
    }
    
}
