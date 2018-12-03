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
//  UserGroup.swift is a structure of a group.
//

import UIKit

class UserGroup: NSObject {
    var groupID: String?
    var name: String?
    var chatid: String?
    var grouptype: String?
    var activitylevel: String?
    var activityLevelInt: Int?
    var city: String?
    
    // Define activityLevelInt based on different level
    func setActivityLevel (level:String){
        activitylevel = level
        if level == "Very light"{
            activityLevelInt = 1
        }
        else if level == "Light"{
            activityLevelInt = 2
        }
        else if level == "Moderate"{
            activityLevelInt = 3
        }
        else if level == "Intense"{
            activityLevelInt = 4
        }
        else if level == "Very Intense"{
            activityLevelInt = 5
        }
        else{
            activityLevelInt = 6
        }
    }
}
