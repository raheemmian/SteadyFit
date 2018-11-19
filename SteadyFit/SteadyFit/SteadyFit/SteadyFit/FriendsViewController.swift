//
//  FriendsViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-10-23.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Raheem Mian, Yimin Long
//  List of Changes: Work in Progress
//  Created table, array for friend list, added emergency button and GPS related code
//
//  Friends View controller displays all of the users friends in a list, and clicking on their friends leads to their friends personal profile.
//  The emergency button is implemented to obtain iPhone's GPS location and bring up iPhone's messaging app with a default message.
//

import UIKit
import MessageUI
import CoreLocation
import FirebaseAuth
import FirebaseDatabase

class FriendsViewController: EmergencyButtonViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    let friendList = ["Friend A", "Friend B", "Friend C", "Friend D"]
    @IBOutlet weak var friendTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        /*initializing the tables and locations*/
        friendTableView.tableFooterView = UIView(frame: .zero)
        friendTableView.delegate = self
        friendTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        /*return the number of rows in the table*/
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        /*return the tablecell name*/
        let tableCell = friendTableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        tableCell.textLabel?.text = friendList[indexPath.row]
        return tableCell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*perform the segue to the friends Profile*/
        performSegue(withIdentifier: "friends", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*provide the title for the navigation bar based on the row selected*/
        var indexPath = self.friendTableView.indexPathForSelectedRow!
        let post = segue.destination as! UserProfileViewController
        post.navigationItem.title = friendList[indexPath.row]
    }

}
