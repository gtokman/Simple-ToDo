//
//  ItemCell.swift
//  ToDo
//
//  Created by g tokman on 12/22/16.
//  Copyright © 2016 garytokman. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    lazy var dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    func configCell(with item: ToDoItem, checked: Bool = false) {
        
        if checked {
            let attributedString = NSAttributedString(
                string: item.title,
                attributes: [NSStrikethroughStyleAttributeName:
                    NSUnderlineStyle.styleSingle.rawValue])
            
            
            titleLabel.attributedText = attributedString
            locationLabel.text = nil
            dateLabel.text = nil
        } else {
            titleLabel.text = item.title
            locationLabel.text = item.location?.name
            
            if let timestamp = item.timestamp {
                let date = Date(timeIntervalSince1970: timestamp)
                dateLabel.text = dateFormatter.string(from: date)
            }
        }
    }
    
}
