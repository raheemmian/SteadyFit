//
//  SettingsViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-11-03.
//  Copyright © 2018 Daycar. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var titleNameArr = ["John Doe", "Notification", "Emergency Button", "Help"]
    var detailArr = ["Edit profile, change password, or log out", "Toggle notfications for vents and groups", "Adjust the message sent to emergency contact", "How-to guides and support"]
    var imageNames = ["Profile", "Notification", "Ambulance", "Help"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableViewCell
        tableCell.detailInfo.text = detailArr[indexPath.row]
        tableCell.titleName.text = titleNameArr[indexPath.row]
        tableCell.imageIcon.image = UIImage(named: imageNames[indexPath.row])
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "settingNavigation" , sender: titleNameArr[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
