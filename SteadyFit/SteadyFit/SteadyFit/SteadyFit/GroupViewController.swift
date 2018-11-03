//
//  GroupViewController.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-10-28.
//  Copyright © 2018 Raheem Mian. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    
   
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var groupDesc: UILabel!
    @IBOutlet weak var groupDescInfo: UILabel!
    @IBOutlet weak var activityLevel: UILabel!
    @IBOutlet weak var activityLevelInfo: UILabel!
    
    @IBOutlet weak var groupStatus: UILabel!
    @IBOutlet weak var groupStatusInfo: UILabel!
   
    var groupName: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        groupLabel.text = groupName
        groupDesc.text = "Group Description:"
        groupDescInfo.text = "(Group Description)"
        activityLevel.text = "Activity Level:"
        activityLevelInfo.text = "(activity level)"
        groupStatus.text = "Group Status:"
        groupStatusInfo.text = "(Group Status)"
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
