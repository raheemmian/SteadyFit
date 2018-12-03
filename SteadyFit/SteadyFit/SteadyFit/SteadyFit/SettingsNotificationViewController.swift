//
//  SettingsNotificationViewController.swift
//  SteadyFit
//
//  Created by Akshay Kumar on 2018-12-01.
//  Copyright © 2018 Daycar. All rights reserved.
// This is the view controller for "Notification Settings" it has one slider, which allows you to toggle event notifications on or off.

import UIKit
//Global variable (singleton) declared so Notifications can be enabled or disabled based on the switch 
//(this variable is used to disable the creation of notificaitons)
struct NotificationBool {
    static var shared = NotificationBool()
    
    var state = true
}

class SettingsNotificationViewController: EmergencyButtonViewController {
    
    @IBOutlet weak var eventNotificationTextField: UILabel!
    
    @IBOutlet weak var output: UITextView!
    //Function for the switch
    //The subtext below the setting title changes based on the switch
    @IBAction func Switch(_ sender: UISwitch) {
        if (sender.isOn == true)
        {
            output.text = "A notifcation will be sent 1 hour prior to the start of the event."
            NotificationBool.shared.state = true
        }
        else
        {
            output.text = "No notifcations will be sent."
            NotificationBool.shared.state = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
