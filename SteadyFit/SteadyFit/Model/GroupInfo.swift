//
//  GroupInfo.swift
//  SteadyFit
//
//  Created by Calvin Liu on 11/15/18.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Alexa Chen
//
//  GroupInfo.swift is a structure of group info for group profile.
//

import UIKit

class GroupInfo : NSObject {
    var groupId : String?
    var activityLevel : String?
    var chatId : String?
    var groupDescription : String?
    var events = [String?]()
    var groupType : String?
    var location : String?
    var name : String?
    var users = [String?]()
}
