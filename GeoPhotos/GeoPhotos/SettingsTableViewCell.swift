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
    let notificationCenter = NotificationCenter.default
    
    override func awakeFromNib() {
        super.awakeFromNib()
        distanceSlider.setValue(Float(searchDistance), animated: true)
        distanceLabel.text = String(Int(distanceSlider.value)) + " KM"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider, forEvent event: UIEvent) {
        let distance: Int = Int(sender.value)
        distanceLabel.text = String(distance) + " KM"
        
        if let touch: UITouch = event.allTouches?.first {
            switch touch.phase {
            case .began:
                break
            case .moved:
                break
            case .ended:
                searchDistance = distance
                notificationCenter.post(name: NSNotification.Name(rawValue: GPNotificationUpdateDistanceFilter), object: nil)
            default:
                break
            }
        }
    }
}
