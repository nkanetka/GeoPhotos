//
//  SettingsViewController.swift
//  GeoPhotos
//
//  Created by Nehal Kanetkar on 2017-02-27.
//  Copyright © 2017 GotIt. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - TableViewDelegate/TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case GPTableViewCell.SearchDistance.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCellDistance") as! SettingsTableViewCell
            return cell
        case GPTableViewCell.TravelMode.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCellTravelMode") as! SettingsTravelModeTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCellTravelMode") as! SettingsTravelModeTableViewCell
            return cell
        }
    }
}
