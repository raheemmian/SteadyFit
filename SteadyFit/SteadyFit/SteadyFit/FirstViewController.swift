//
//  FirstViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-10-23.
//  Copyright © 2018 Raheem Mian. All rights reserved.
//

//Home
import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var events = ["dog", "cat"]
    var tableFooterView: UIView?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = UITableViewCell(style: UITableViewCell.CellStyle.default
            , reuseIdentifier: "cell")
        tableCell.textLabel?.text = events[indexPath.row]
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Events"
    }
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var ActivityTracker: UIButton!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet var profilePicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        ActivityTracker.layer.borderWidth = 1.0;
        //name.layer.borderWidth = 1.0
      
        

    }


}

