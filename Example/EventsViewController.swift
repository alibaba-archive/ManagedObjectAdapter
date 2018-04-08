//
//  EventsViewController.swift
//  Example
//
//  Created by Xin Hong on 16/7/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreData
import ManagedObjectAdapter

class EventsViewController: UITableViewController {
    var events = [Event]()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()

        let event = events.first
        let moEvent = event?.toManagedObject(in: CoreDataManager.context) as? _Event
        print("\n********** Transferred ManagedObject **********")
        print(moEvent ?? "moEvent is nil")

        let eventModel = Event.model(from: moEvent!)
        print("\n********** Transferred Model **********")
        print(eventModel ?? "eventModel is nil")
    }

    // MARK: - Helper
    fileprivate func setupUI() {
        navigationItem.title = "Events"
        tableView.tableFooterView = UIView()
    }

    fileprivate func loadData() {
        guard let path = Bundle(identifier: "Teambition.ManagedObjectAdapter.Example")?.path(forResource: "events", ofType: "json") ?? Bundle.main.path(forResource: "events", ofType: "json") else {
            return
        }
        print(path)
        
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return
        }
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] else {
            return
        }
        
        guard let events = json?.compactMap({ (object) -> Event? in
            return Event(object)
        }) else {
            return
        }
        self.events = events
        tableView.reloadData()
    }

    // MARK: - Table view data source and delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "EventCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "EventCell")
        }
        let event = events[indexPath.row]
        cell?.textLabel?.text = event.title
        cell?.detailTextLabel?.text = event.recurrence?.rule
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
