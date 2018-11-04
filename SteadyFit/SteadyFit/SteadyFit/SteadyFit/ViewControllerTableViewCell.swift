//
//  ViewControllerTableViewCell.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-11-03.
//  Copyright © 2018 Raheem Mian. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var DetailInfo: UILabel!
    @IBOutlet weak var TitleName: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
