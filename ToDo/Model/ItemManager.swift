//
//  ItemManager.swift
//  ToDo
//
//  Created by g tokman on 12/21/16.
//  Copyright © 2016 garytokman. All rights reserved.
//

import UIKit

class ItemManager: NSObject {
    var toDoCount: Int { return toDoItems.count }
    var doneCount: Int { return doneItems.count }
    private var toDoItems: [ToDoItem] = []
    private var doneItems: [ToDoItem] = []
    
    var toDoPathURL: URL {
        let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let documentURL = fileURLs.first else {
            print("Something went wrong. Documents url could not be found")
            fatalError()
        }
        
        return documentURL.appendingPathComponent("toDoItems.plist")
    }
    
    override init() {
        super.init()
        
        if let nsToDoItems = NSArray(contentsOf: toDoPathURL) {
            for dict in nsToDoItems {
                if let toDoItem = ToDoItem(dict: dict as! [String: Any]) {
                    toDoItems.append(toDoItem)
                }
            }
        }
        
        NotificationCenter.default
            .addObserver(self, selector: #selector(save),
                         name: .UIApplicationWillResignActive, object: nil)
    }
    
    func add(_ item: ToDoItem) {
        if !toDoItems.contains(item) {
            toDoItems.append(item)
        }
    }
    
    func item(at index: Int) -> ToDoItem {
        return toDoItems[index]
    }
    
    func checkItem(at index: Int) {
        let item = toDoItems.remove(at: index)
        doneItems.append(item)
    }
    
    func uncheckItem(at index: Int) {
        let item = doneItems.remove(at: index)
        toDoItems.append(item)
    }
    
    func doneItem(at index: Int) -> ToDoItem {
        return doneItems[index]
    }
    
    func removeAll() {
        toDoItems.removeAll()
        doneItems.removeAll()
    }
    
    func save() {
        let nsToDoItems = toDoItems.map { $0.plistDict }
        
        guard nsToDoItems.count > 0 else {
            try? FileManager.default.removeItem(at: toDoPathURL)
            return
        }
        
        do {
            let plistData = try PropertyListSerialization.data(fromPropertyList: nsToDoItems, format: .xml, options: PropertyListSerialization.WriteOptions(0))
            
            try plistData.write(to: toDoPathURL, options: .atomic)
        } catch {
            print(error)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        save()
    }
}
