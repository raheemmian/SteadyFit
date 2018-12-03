//
//  ChatsViewController.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-11-03.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Dickson Chum, Raheem Mian, Alexa Chen
//  List of Changes: added arrays, table for chat, added emergency button, populated groups
//
//  Edited by: Alexa Chen
//  List of changes: populated chat for friends
//
//  ChatsViewController.swift is linked to a view controller which shows the list of friend and group chats the user is in.
//

import UIKit
import MessageUI
import CoreLocation
import FirebaseDatabase
import FirebaseAuth

class ChatsViewController: EmergencyButtonViewController, UITableViewDataSource, UITableViewDelegate{
    // Variables declaration
    var chatListTitle = ["Private Chats", "Group Chats"]
    var chatListContent = [[String](), [String]()]
    @IBOutlet weak var chatListTableView: UITableView!
    @IBAction func emergencyButton(_ sender: Any) {sendText()}
    var privateChatIDList = [String]()
    var publicChatIDList = [String]()
    var publicGroupList = [String]()
    var privateGroupList = [String]()
    let currentUserID = (Auth.auth().currentUser?.uid)!
    var groupsHandle:DatabaseHandle?
    let groupsRef:DatabaseReference? = Database.database().reference()
    var currentUserName: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Get all the groups the current user has
        self.groupsRef?.child("Users").child(currentUserID).observe(DataEventType.value, with: {
            (snapshot) in
            print (snapshot)
            self.chatListContent.removeAll()
            self.privateChatIDList.removeAll()
            self.publicChatIDList.removeAll()
            self.publicGroupList.removeAll()
            self.privateGroupList.removeAll()
            self.currentUserName = snapshot.childSnapshot(forPath: "name").value as!String
            for groupsSnapshot in snapshot.childSnapshot(forPath: "Groups").children.allObjects as! [DataSnapshot] {
                guard let dictionary = groupsSnapshot.value as? [String: AnyObject] else {continue}
                let grouptype = dictionary["grouptype"] as!String
                // assign the groups to the correct categories
                if  grouptype == "public" || grouptype == "Public"{
                    self.publicGroupList.append((dictionary["name"] as! String))
                    self.publicChatIDList.append((dictionary["chatid"] as! String))
                }
                else if grouptype == "Private" || grouptype == "private"{
                    self.privateGroupList.append((dictionary["name"] as! String))
                    self.privateChatIDList.append((dictionary["chatid"] as! String))
                }
            }
            // loop through the "Friends" node
            for friendSnapshot in snapshot.childSnapshot(forPath: "Friends").children.allObjects as! [DataSnapshot] {
                guard let frienddictionary = friendSnapshot.value as? [String: AnyObject] else {continue}
                self.privateGroupList.append(frienddictionary["name"] as! String)
                self.privateChatIDList.append(frienddictionary["chatid"] as! String)
            }
            self.chatListContent = [self.privateGroupList, self.publicGroupList]
            DispatchQueue.main.async() {
                self.chatListTableView.reloadData()
            }
        })
    }
    
    // Set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return chatListTitle.count
    }
    // Set sections title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return chatListTitle[section]
    }
    // Set number of contents of each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatListContent[section].count
    }
    // Set contents
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        cell.textLabel?.text = chatListContent[indexPath.section][indexPath.row]
        return cell
    }
    // Perform segue when the row is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showGroupChat", sender: self)
        chatListTableView.deselectRow(at: indexPath, animated: true)
    }
    // Override segue action if private chat is clicked
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = self.chatListTableView.indexPathForSelectedRow!
        let post = segue.destination as! GroupChatTableViewController
        post.navigationItem.title = chatListContent[indexPath.section][indexPath.row]
        if (indexPath.section == 0){ // private chats
            post.chatID = privateChatIDList[indexPath.row]
        }
        else{ // public chats
            post.chatID = publicChatIDList[indexPath.row]
        }
        post.myUserName = currentUserName
        post.myUserID = currentUserID
    }
}
