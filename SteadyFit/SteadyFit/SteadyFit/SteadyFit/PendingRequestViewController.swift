//
//  PendingRequestViewController.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-11-24.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Dickson Chum
//  List of Changes: added Accept and Decline button, added buttonAction to update database node depends on which button is clicked.
//
//  PendingRequestViewController.swift is connected to PendingRequestViewController in PendingRequest.storyboard.
//  It shows the list of friend and group requests, user can accept or decline the invitation.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PendingRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //  Variables declaration
    var requestTableSections = ["Friend Request", "Group Request"]
    var requestTableContents: [[String]] = [[],[]]
    var groupIDs: [String] = []
    var groupTypes: [String] = []
    var friendIDs: [String] = []
    var friendChats: [String] = []
    var groupChats: [String] = []
    var ref:DatabaseReference? = Database.database().reference()
    let currentUserID = Auth.auth().currentUser?.uid
    var currentUserName = ""
    let cellID = "requestCell"
    
    @IBOutlet weak var requestTableView: UITableView!
    
    //  Load view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        requestTableView.register(RequestTableViewCell.self, forCellReuseIdentifier: cellID)
        requestTableView.dataSource = self
        requestTableView.delegate = self
        requestTableView.tableFooterView = UIView(frame: .zero)
        
        //  Get information from database
        if currentUserID != nil {
            ref?.child("Groups").observe(DataEventType.value, with: {
                (groupsnapshot) in
                self.requestTableContents[0].removeAll()
                self.requestTableContents[1].removeAll()
                self.groupIDs.removeAll()
                self.friendIDs.removeAll()
                self.ref?.child("Users/\(self.currentUserID!)/name").observe(DataEventType.value, with: {
                    (currentUserNameSnap) in
                    self.currentUserName = currentUserNameSnap.value as? String ?? ""
                })
                
                for rest in groupsnapshot.children.allObjects as! [DataSnapshot] {
                    guard let Groupdictionary = rest.value as? [String: AnyObject] else {continue}
                    guard let groupType = Groupdictionary["grouptype"] as? String else {continue}
                    guard let chatId = Groupdictionary["chatid"] as? String else {continue}
                    // Get pending friend requests
                    if groupType == "Friends"{
                        guard let user2Dictionary = rest.childSnapshot(forPath: "user2").childSnapshot(forPath: self.currentUserID!).value as? [String: AnyObject] else {continue}
                        guard let isJoined = user2Dictionary["joined"] as? Int else {continue}
                        if isJoined == 0{
                            for newfriend in rest.childSnapshot(forPath: "user1").children.allObjects as! [DataSnapshot] {
                                let friendID = newfriend.key
                                guard let friendDictionary = newfriend.value as? [String: AnyObject] else {continue}
                                guard let friendName = friendDictionary["name"] as? String else {continue}
                                self.friendIDs.append(friendID)
                                self.requestTableContents[0].append(friendName)
                                self.friendChats.append(chatId)
                            }
                        }
                    }
                    // Get pending group invites
                    else{
                        guard let userDictionary = rest.childSnapshot(forPath: "users").childSnapshot(forPath: self.currentUserID!).value as? [String: AnyObject] else {continue}
                        guard let isJoined = userDictionary["joined"] as? Int else {continue}
                        if (isJoined == 0){
                            let groupId = rest.key
                            self.requestTableContents[1].append(Groupdictionary["name"] as? String ?? "")
                            self.groupIDs.append(groupId)
                            self.groupTypes.append(groupType)
                            self.groupChats.append(chatId)
                        }
                    }
                }
                DispatchQueue.main.async() {
                    self.requestTableView.reloadData()
                }
            })
        }
    }
    
    // Set height of each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    //  Set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return requestTableSections.count
    }
    
    //  Set title for header in section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return requestTableSections[section]
    }
    
    //  Set number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestTableContents[section].count
    }
    
    //  Setup cell based on each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! RequestTableViewCell
        cell.textLabel?.text = requestTableContents[indexPath.section][indexPath.row]
        setupCell(cell: cell, section: indexPath.section, row: indexPath.row)
        return cell
    }
    
    //  Setup cell based on corresponding section and row
    //  Assign value to variables in RequestTableViewCell
    private func setupCell(cell: RequestTableViewCell, section: Int, row: Int){
        cell.section = section
        cell.row = row
        
        // section = 0 --> friend request
        if(section == 0){
            cell.friendID = friendIDs[row]
            cell.friendGroupID = "Group" + cell.friendID + self.currentUserID!
            cell.chatID = friendChats[row]
            cell.friendName = requestTableContents[0][row]
            cell.friendChat = friendChats[row]
            cell.post = ["/Users/\(self.currentUserID!)/Friends/\(cell.friendID)": ["name": cell.friendName, "chatid":cell.friendChat],
                         "/Users/\(cell.friendID)/Friends/\(self.currentUserID!)": ["name": self.currentUserName, "chatid":cell.friendChat],
                         "/Groups/\(cell.friendGroupID)/user2/\(self.currentUserID!)/joined": 1]
        }
        // section = 1 --> group request
        else{
            cell.groupID = groupIDs[row]
            cell.chatID = groupChats[row]
            cell.groupName = requestTableContents[1][row]
            cell.groupType = groupTypes[row]
            cell.groupChat = groupChats[row]
            cell.post = ["/Users/\(self.currentUserID!)/Groups/\(cell.groupID)": ["name":cell.groupName, "grouptype":cell.groupType, "chatid":cell.groupChat],
                          "Groups/\(cell.groupID)/users/\(self.currentUserID!)/joined": 1]
        }

    }
}
