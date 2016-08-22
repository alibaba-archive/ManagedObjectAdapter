//
//  ProjectsViewController.swift
//  Example
//
//  Created by Xin Hong on 16/7/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreData
import ManagedObjectAdapter

class ProjectsViewController: UITableViewController {
    var projects = [Project]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()

        let project = projects.first
        let moProject = project?.toManagedObject(CoreDataManager.context) as? _Project
        do {
            try CoreDataManager.context.save()
        } catch _ {

        }
        print("\n********** Transferred ManagedObject **********")
        print(moProject)

        let projectModel = Project.modelFromManagedObject(moProject!)
        print("\n********** Transferred Model **********")
        print(projectModel)
        if let firstEvent = projectModel?.events?.first {
            print(firstEvent)
        }
    }

    // MARK: - Life cycle
    private func setupUI() {
        navigationItem.title = "Projects"
        tableView.tableFooterView = UIView()
    }

    // MARK: - Helper
    private func loadData() {
        guard let path = NSBundle(identifier: "Teambition.ManagedObjectAdapter.Example")?.pathForResource("projects", ofType: "json") ?? NSBundle.mainBundle().pathForResource("projects", ofType: "json") else {
            return
        }
        print(path)
        
        guard let jsonData = NSData(contentsOfFile: path) else {
            return
        }
        guard let json = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? [[String: AnyObject]] else {
            return
        }

        guard let projects = json?.flatMap({ (object) -> Project? in
            return Project(object)
        }) else {
            return
        }
        self.projects = projects
        tableView.reloadData()
    }

    // MARK: - Table view data source and delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ProjectCell")
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "ProjectCell")
        }
        let project = projects[indexPath.row]
        cell?.textLabel?.text = project.name
        cell?.detailTextLabel?.text = project.organization?.name
        return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let eventsViewController = EventsViewController()
        navigationController?.pushViewController(eventsViewController, animated: true)
    }
}
