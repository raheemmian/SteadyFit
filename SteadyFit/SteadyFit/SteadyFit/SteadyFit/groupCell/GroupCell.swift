//
//  GroupCell.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-10-30.
//  Copyright © 2018 Raheem Mian. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    
    @IBOutlet weak var groupName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func groupInfo(_ sender: UIButton) {
    }
    
    func groupInit(text: String){
        self.groupName.text = text
        self.groupName.textColor = UIColor.black
        self.contentView.backgroundColor = UIColor.lightGray
        
    }
}
