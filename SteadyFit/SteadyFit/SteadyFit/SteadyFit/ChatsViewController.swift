//
//  ChatsViewController.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-11-03.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Dickson Chum, Raheem Mian, Alexa Chen
//  List of Changes: added arrays, table for chat, added emergency button and GPS related code, populated groups
//
//  ChatsViewController.swift is linked to a view controller which shows the list of chat group the user is in.
//


import UIKit
import MessageUI
import CoreLocation
import FirebaseDatabase
import FirebaseAuth

class ChatsViewController: EmergencyButtonViewController, UITableViewDataSource, UITableViewDelegate{
    
    var chatListTitle = ["Private Chats", "Group Chats"]
    var chatListContent = [[String](), [String]()]
    @IBOutlet weak var chatListTableView: UITableView!
    @IBAction func emergencyButton(_ sender: Any) {sendText()}

    
    var chatIDList = [String]()
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
            self.chatIDList.removeAll()
            self.publicGroupList.removeAll()
            self.privateGroupList.removeAll()
            self.currentUserName = snapshot.childSnapshot(forPath: "name").value as!String
            for groupsSnapshot in snapshot.childSnapshot(forPath: "Groups").children.allObjects as! [DataSnapshot] {
                print (groupsSnapshot)
                guard let dictionary = groupsSnapshot.value as? [String: AnyObject] else {continue}
                self.chatIDList.append((dictionary["chatid"] as! String))
                var grouptype = dictionary["grouptype"] as!String
                // assign the groups to the correct categories
                if  grouptype == "public" || grouptype == "Public"{
                    self.publicGroupList.append((dictionary["name"] as! String))
                }
                else{
                    self.privateGroupList.append((dictionary["name"] as! String))
                }
            }
            self.chatListContent = [self.privateGroupList, self.publicGroupList]
            DispatchQueue.main.async() {
                // Check how many times the table is loaded
                print ("loaded table\n")
                self.chatListTableView.reloadData()
            }
        })
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return chatListTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return chatListTitle[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatListContent[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        cell.textLabel?.text = chatListContent[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showGroupChat", sender: self)
        chatListTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = self.chatListTableView.indexPathForSelectedRow!
        let post = segue.destination as! GroupChatTableViewController
        post.navigationItem.title = chatListContent[indexPath.section][indexPath.row]
        post.chatID = chatIDList[indexPath.row]
        post.myUserName = currentUserName
        post.myUserID = currentUserID
    }
}
