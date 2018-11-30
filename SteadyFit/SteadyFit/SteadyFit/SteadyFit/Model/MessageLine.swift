//
//  MessageLine.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-11-05.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Dickson Chum
//  
//  MessageLine.swift is the structure of a message for Firebase.
//


import UIKit

class MessageLine: NSObject {
    var message: String?
    var timeStamp: String?  // yyyy-mm-dd hh:mm:ss
    var senderName: String?
    var senderID: String?
    var senderProfile: UIImage?
}
