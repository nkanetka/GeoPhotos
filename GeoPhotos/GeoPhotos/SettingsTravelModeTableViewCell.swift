//
//  SettingsTravelModeTableViewCell.swift
//  GeoPhotos
//
//  Created by Nehal Kanetkar on 2017-02-28.
//  Copyright © 2017 GotIt. All rights reserved.
//

import UIKit

class SettingsTravelModeTableViewCell: UITableViewCell {
    @IBOutlet weak var travelModeSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        travelModeSwitch.setOn(travelMode, animated: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func travelModeSwitchToggled(_ sender: UISwitch) {
        travelMode = sender.isOn
    }
}
