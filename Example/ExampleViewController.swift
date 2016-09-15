//
//  ExampleViewController.swift
//  Example
//
//  Created by Xin Hong on 16/7/27.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import CoreData
import ObjectMapper
import ManagedObjectAdapter

class ExampleViewController: UITableViewController {
    var organizations = [Organization]()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(CoreDataManager.coreDataStorePath)
        setupUI()
        loadData()

        let org = organizations.first
        let moOrg = org?.toManagedObject(in: CoreDataManager.context) as? _Organization
        do {
            try CoreDataManager.context.save()
        } catch _ {

        }
        print("\n********** Transferred ManagedObject **********")
        print(moOrg)

        let orgModel = Organization.model(from: moOrg!)
        print("\n********** Transferred Model **********")
        print(orgModel)
        if let firstProject = orgModel?.projects?.first {
            print(firstProject)
        }
    }

    // MARK: - Helper
    fileprivate func setupUI() {
        navigationItem.title = "Example"
        tableView.tableFooterView = UIView()
    }

    fileprivate func loadData() {
        guard let path = Bundle(identifier: "Teambition.ManagedObjectAdapter.Example")?.path(forResource: "organizations", ofType: "json") ?? Bundle.main.path(forResource: "organizations", ofType: "json") else {
            return
        }
        print(path)

        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return
        }
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] else {
            return
        }

        guard let organizations = json?.flatMap({ (object) -> Organization? in
            return Organization(object)
        }) else {
            return
        }
        self.organizations = organizations
        tableView.reloadData()
    }

    // MARK: - Table view data source and delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "OrganizationCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "OrganizationCell")
        }
        let organization = organizations[indexPath.row]
        cell?.textLabel?.text = organization.name
        cell?.detailTextLabel?.text = String(organization.projects?.count ?? 0)
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let projectsViewController = ProjectsViewController()
        navigationController?.pushViewController(projectsViewController, animated: true)
    }
}
