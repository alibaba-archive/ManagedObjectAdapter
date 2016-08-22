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
        let moEvent = event?.toManagedObject(CoreDataManager.context) as? _Event
        print("\n********** Transferred ManagedObject **********")
        print(moEvent)

        let eventModel = Event.modelFromManagedObject(moEvent!)
        print("\n********** Transferred Model **********")
        print(eventModel)
    }

    // MARK: - Helper
    private func setupUI() {
        navigationItem.title = "Events"
        tableView.tableFooterView = UIView()
    }

    private func loadData() {
        guard let path = NSBundle(identifier: "Teambition.ManagedObjectAdapter.Example")?.pathForResource("events", ofType: "json") ?? NSBundle.mainBundle().pathForResource("events", ofType: "json") else {
            return
        }
        print(path)
        
        guard let jsonData = NSData(contentsOfFile: path) else {
            return
        }
        guard let json = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? [[String: AnyObject]] else {
            return
        }
        
        guard let events = json?.flatMap({ (object) -> Event? in
            return Event(object)
        }) else {
            return
        }
        self.events = events
        tableView.reloadData()
    }

    // MARK: - Table view data source and delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("EventCell")
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "EventCell")
        }
        let event = events[indexPath.row]
        cell?.textLabel?.text = event.title
        cell?.detailTextLabel?.text = event.recurrence?.rule
        return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
