//
//  SettingsTableViewCell.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-11-03.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Raheem Mian
//  List of Changes: Work in Progress
//  Added labels for settings
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailInfo: UILabel!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
