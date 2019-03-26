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
        let moProject = project?.toManagedObject(in: CoreDataManager.context) as? _Project
        do {
            try CoreDataManager.context.save()
        } catch _ {

        }
        print("\n********** Transferred ManagedObject **********")
        print(moProject ?? "moProject is nil")

        let projectModel = Project.model(from: moProject!)
        print("\n********** Transferred Model **********")
        print(projectModel ?? "projectModel is nil")
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
        guard let path = Bundle(identifier: "Teambition.ManagedObjectAdapter.Example")?.path(forResource: "projects", ofType: "json") ?? Bundle.main.path(forResource: "projects", ofType: "json") else {
            return
        }
        print(path)
        
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return
        }
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] else {
            return
        }

        let projects = json.compactMap { Project($0) }
        self.projects = projects
        tableView.reloadData()
    }

    // MARK: - Table view data source and delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "ProjectCell")
        }
        let project = projects[indexPath.row]
        cell?.textLabel?.text = project.name
        cell?.detailTextLabel?.text = project.organization?.name
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let eventsViewController = EventsViewController()
        navigationController?.pushViewController(eventsViewController, animated: true)
    }
}
