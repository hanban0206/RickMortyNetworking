//
//  FilterTableViewController.swift
//  RickMortyNetworking
//
//  Created by Shawn Gee on 7/9/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

protocol FilterDelegate: AnyObject {
    func filterDidSelect(gender: Gender?)
    func filterDidSelect(status: Status?)
}

class FilterTableViewController: UITableViewController {

    // MARK: - Public Properties
    
    weak var delegate: FilterDelegate?
    
    var gender: Gender? { didSet { delegate?.filterDidSelect(gender: gender) }}
    var status: Status? { didSet { delegate?.filterDidSelect(status: status) }}
    
    // MARK: - IBActions
    
    @IBAction func dismissView(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let gender = gender, let row = Gender.allCases.firstIndex(of: gender) {
            let indexPath = IndexPath(row: row, section: 0)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        if let status = status, let row = Status.allCases.firstIndex(of: status) {
            let indexPath = IndexPath(row: row, section: 1)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return Gender.allCases.count
        } else {
            return Status.allCases.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Gender"
        } else {
            return "Status"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = Gender.allCases[indexPath.row].rawValue.capitalized
        } else {
            cell.textLabel?.text = Status.allCases[indexPath.row].rawValue.capitalized
        }

        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            gender = Gender.allCases[indexPath.row]
        } else {
            status = Status.allCases[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 {
            gender = nil
        } else {
            status = nil
        }
        
        return indexPath
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.indexPathsForSelectedRows?
            .filter { $0.section == indexPath.section }
            .forEach { tableView.deselectRow(at: $0, animated: false) }
        return indexPath
    }
}
