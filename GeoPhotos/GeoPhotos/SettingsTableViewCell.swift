//
//  SettingsTableViewCell.swift
//  GeoPhotos
//
//  Created by Nehal Kanetkar on 2017-02-27.
//  Copyright © 2017 GotIt. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        distanceLabel.text = String(Int(distanceSlider.value)) + " KM"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        distanceLabel.text = String(Int(sender.value)) + " KM"
    }

}
