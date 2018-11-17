//
//  UserGroup.swift
//  SteadyFit
//
//  Created by Alexa Chen on 2018-11-02.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Alexa Chen
//  List of Changes: created UserGroup as NSObject.
//
//  AppDelegate.swift is created along with project creation. It is needed for the app to launch properly.
//

import UIKit

class UserGroup: NSObject {
    var groupID: String?
    var name: String?
    var chatid: String?
    var grouptype: String?
    var activitylevel: String?
    var acivitylevelInt: Int?
    var city: String?
    
    func setActivityLevel (level:String){
        activitylevel = level
        if level == "Very light"{
            acivitylevelInt = 1
        }
        else if level == "Light"{
            acivitylevelInt = 2
        }
        else if level == "Moderate"{
            acivitylevelInt = 3
        }
        else if level == "Intense"{
            acivitylevelInt = 4
        }
        else if level == "Very Intense"{
            acivitylevelInt = 5
        }
        else{
            acivitylevelInt = 6
        }
    }
}
