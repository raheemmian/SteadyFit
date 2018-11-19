//
//  GroupProfileViewController.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-10-28.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Dickson Chum
//  List of Changes: added labels, table and arrays for table, created segues for table view, added emergency button and GPS related code
//
//  GroupProfileViewController.swift is linked to Group Profile of the UI, which shows group information.
//  The emergency button is implemented to obtain iPhone's GPS location and bring up iPhone's messaging app with a default message.
//

import UIKit
import MessageUI
import CoreLocation
import Firebase
import FirebaseDatabase
import FirebaseAuth


class GroupProfileViewController: EmergencyButtonViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var groupDesc: UILabel!
    @IBOutlet weak var groupDescInfo: UILabel!
    @IBOutlet weak var activityLevel: UILabel!
    @IBOutlet weak var activityLevelInfo: UILabel!
    @IBOutlet weak var groupStatus: UILabel!
    @IBOutlet weak var groupStatusInfo: UILabel!
    @IBOutlet weak var eventTableView: UITableView!
    
    @IBAction func joinGroup(_ sender: UIButton) {joinThisGroup()}
    @IBAction func emergencyButton(_ sender: UIButton) {sendText()}
    var ref:DatabaseReference? = Database.database().reference()
    var refHandle:DatabaseHandle?
    var groupId : String!
    var groupTableSections = ["Members", "Events"]
    var groupTableContents = [["More"], []]
    var groupTableEventID = [String]()
    var isAddEvent: Bool = false;
    var userList = [String]()
    var groupInfo: GroupInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.delegate = self
        eventTableView.dataSource = self
        
        refHandle = self.ref?.child("Groups").child(groupId).observe(DataEventType.value, with: { (snapshot) in
        
            if let groupInfo = snapshot.value as? [String: AnyObject]{
                let myGroupInfo = GroupInfo()
                myGroupInfo.activityLevel = groupInfo["activitylevel"] as?String
                myGroupInfo.chatId = groupInfo["chatid"] as?String
                myGroupInfo.groupDescription = groupInfo["description"] as?String
                
                if (groupInfo["events"] != nil){
                    for sessionSnapshot in snapshot.childSnapshot(forPath: "events").children.allObjects as![DataSnapshot]{
                        let myGroupEvents = GroupEvents()
                        myGroupEvents.sessionId = sessionSnapshot.key
                        myGroupEvents.eventName = sessionSnapshot.value as?String
                        myGroupInfo.events.append(myGroupEvents.eventName)
                        self.groupTableEventID.append(myGroupEvents.sessionId as! String)
                    }
                }
                
                for events in myGroupInfo.events{
                    self.groupTableContents[1].append((events)!)
                }
                
                myGroupInfo.groupType = groupInfo["grouptype"] as?String
                myGroupInfo.location = groupInfo["location"] as?String
                myGroupInfo.name = groupInfo["name"] as?String
                
                if (groupInfo["users"] != nil){
                    for userSnapshot in snapshot.childSnapshot(forPath: "users").children.allObjects as![DataSnapshot]{
                        if let groupUser = userSnapshot.value as? [String : AnyObject] {
                            let myGroupUser = GroupUser()
                            myGroupUser.joined = (groupUser["joined"] as!Int)
                            myGroupUser.userName = groupUser["name"] as?String
                            if (myGroupUser.joined == 1){
                                myGroupInfo.users.append(myGroupUser.userName)
                            }
                        }
                    }
                }
                self.groupInfo = myGroupInfo
                
                self.userList = myGroupInfo.users as! [String]
                
                self.groupDesc.text = "Group Description:"
                self.groupDescInfo.text = myGroupInfo.groupDescription
                self.activityLevel.text = "Activity Level:"
                self.activityLevelInfo.text = myGroupInfo.activityLevel
                self.groupStatus.text = "Group Status:"
                self.groupStatusInfo.text = myGroupInfo.groupType
            }
            DispatchQueue.main.async{
                self.eventTableView.reloadData()
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupTableSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupTableSections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupTableContents[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = eventTableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
        cell.textLabel?.text = groupTableContents[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: groupTableSections[indexPath.section], sender: self)
        eventTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if isAddEvent == false {
            var indexPath = self.eventTableView.indexPathForSelectedRow!
            if(indexPath.section == 0){
                let destination = segue.destination as! GroupMemberListTableViewController
                destination.navigationItem.title = groupTableContents[indexPath.section][indexPath.row]
                destination.memberList = userList
            }
            else{
                let destination = segue.destination as! UserEventsViewController
                destination.navigationItem.title = groupTableContents[indexPath.section][indexPath.row]
                destination.eventId = groupTableEventID[indexPath.row]
            }
        }
        else{
            let destination = segue.destination as! AddEventViewController
            destination.groupID = self.groupId
            isAddEvent = false
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        let label = UILabel()
        label.text = groupTableSections[section]
        label.frame = CGRect(x: 10, y: 0, width: 100, height: 22)
        headerView.addSubview(label)
        if section == 1{
            let image = UIImage(named: "plus")
            let button = UIButton()
            button.frame = CGRect(x:350, y: 0, width: 22, height: 22)
            button.setImage(image, for: .normal)
            button.layer.borderWidth = 1
            button.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
            button.addTarget(self, action: #selector(addEventsButtonPressed), for: .touchUpInside)
            headerView.addSubview(button)
        }
        return headerView
    }
    @objc func addEventsButtonPressed(sender: UIButton!){
        isAddEvent = true;
        performSegue(withIdentifier: "AddEvents" , sender: self)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    

    func joinThisGroup() {
        let currentuserID = Auth.auth().currentUser?.uid
        self.ref?.child("Users").child(currentuserID!).child("name").observe(.value, with: { snapshot in
            guard let userName = snapshot.value as? String else {
                return
            }
            self.ref?.child("Groups").child(self.groupId).child("users")
                .child(currentuserID!).setValue(["joined" : 1, "name" : userName])
            self.ref?.child("Users").child(currentuserID!).child("Groups").child(self.groupId)
                .setValue(["chatid": self.groupInfo?.chatId, "grouptype": self.groupInfo?.groupType, "name": self.groupInfo?.name])
        })
    }

    
}
