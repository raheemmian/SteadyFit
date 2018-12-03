//
//  SettingsViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-11-03.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Raheem Mian
//  List of Changes: Work in Progress
//  Added table, arrays for settings, added emergency button and GPS related code
//
//  SettingsViewController allows for editting personal information, notification settings, emergency button settings, and help settings. For now only the table is implemented displaying the different sections listed. 
//  The emergency button is implemented to obtain iPhone's GPS location and bring up iPhone's messaging app with a default message.
//

import UIKit
import MessageUI
import CoreLocation

class SettingsViewController: EmergencyButtonViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settingTableView: UITableView!
    var titleNameArr = ["Edit Profile", "Notification", "Emergency Button", "Help"]
    var detailArr = ["Edit personal info, change password, or log out", "Toggle notfications for Events", "Edit the message being sent to emergency contact", "FAQ, Disclaimer"]
    var imageNames = ["Profile", "Notification", "Ambulance", "Help"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*return the amount of rows in settings*/
        return titleNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*Fill up the detail */
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableViewCell
        tableCell.detailInfo.text = detailArr[indexPath.row]
        tableCell.titleName.text = titleNameArr[indexPath.row]
        tableCell.imageIcon.image = UIImage(named: imageNames[indexPath.row])
        return tableCell
    }
    
    // Setup tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3{
            performSegue(withIdentifier: "help", sender: titleNameArr[indexPath.row])
        }
        else if indexPath.row == 2{
            performSegue(withIdentifier: "emergency" , sender: titleNameArr[indexPath.row])
        }
        else if indexPath.row == 0{
            performSegue(withIdentifier: "settingNavigation" , sender: titleNameArr[indexPath.row])
        }
        else if indexPath.row == 1{
            performSegue(withIdentifier: "notification" , sender: titleNameArr[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
