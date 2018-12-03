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
    // Variables declaration
    var ref:DatabaseReference?
    var refHandle:DatabaseHandle?
    let currentuserID = (Auth.auth().currentUser?.uid)!
    var friendList: [String] = []
    var friendIdList: [String] = []
    @IBOutlet weak var friendTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initializing the tables
        friendTableView.tableFooterView = UIView(frame: .zero)
        friendTableView.delegate = self
        friendTableView.dataSource = self
        
        ref = Database.database().reference()
            // load friend list
            ref?.child("Users").child(currentuserID).child("Friends").observe(DataEventType.value, with: {(snapshot) in
                self.friendList.removeAll()
                self.friendIdList.removeAll()
                for rest in snapshot.children.allObjects as! [DataSnapshot]{
                    guard let dictionary = rest.value as? [String: AnyObject] else {continue}
                    let friendName = dictionary["name"] as?String
                    let friendId = rest.key
                    if (friendName != nil && friendId != ""){
                        self.friendList.append(friendName!)
                        self.friendIdList.append(friendId)
                    }
                }
                DispatchQueue.main.async() {
                    self.friendTableView.reloadData()
                }
            })
        
        self.ref!.child("Users").child(currentuserID).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let userDictionary = snapshot.value as? [String: AnyObject]
            print (snapshot)
            
            if userDictionary != nil{
                self.currentUserEmergencyNum = userDictionary!["emergencycontact"] as? String
                self.emergencyMessage = userDictionary!["emergencymessage"] as? String
            }
        })
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
        let destination = segue.destination as! UserProfileViewController
        destination.navigationItem.title = friendList[indexPath.row]
        destination.friendUserId = friendIdList[indexPath.row]
    }
}
