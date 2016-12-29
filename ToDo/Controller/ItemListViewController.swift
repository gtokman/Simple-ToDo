//
//  ItemListViewController.swift
//  ToDo
//
//  Created by g tokman on 12/22/16.
//  Copyright © 2016 garytokman. All rights reserved.
//

import UIKit

@objc protocol ItemManagerSettable {
    var itemManager: ItemManager? { get set }
}

class ItemListViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate & ItemManagerSettable)!
    
    let itemManager = ItemManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataProvider.itemManager = itemManager
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDetails(sender:)), name: NSNotification.Name("ItemSelectedNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController {
            nextViewController.itemManager = self.itemManager
            present(nextViewController, animated: true, completion: nil)
        }
    }
    
    func showDetails(sender: NSNotification) {
        guard let index = sender.userInfo?["index"] as? Int else {
            fatalError()
        }
        
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            nextViewController.itemInfo = (itemManager, index)
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
}
