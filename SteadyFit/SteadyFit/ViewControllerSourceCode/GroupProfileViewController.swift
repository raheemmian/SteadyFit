//
//  GroupProfileViewController.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-10-28.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Dickson Chum, Calvin Liu, Alexa Chen, Raheem Mian
//  List of Changes: added labels, table and arrays for table, created segues for table view, added emergency button and GPS related code
//
//  Resolved bug:
//  Join Button does not hide when the user is in the group
//
//  GroupProfileViewController.swift is linked to Group Profile of the UI, which shows group information, and add an event and
//  go to a an event to see the information
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
    @IBOutlet weak var joinGroupButton: UIButton!
    
    @IBAction func joinGroup(_ sender: UIButton) { joinThisGroup() }
    var ref:DatabaseReference? = Database.database().reference()
    var refHandle:DatabaseHandle?
    var groupId : String!
    var groupTableSections = ["Members", "Events"]
    var groupTableContents = [["More"], []]
    var myUserID = (Auth.auth().currentUser?.uid)!
    var groupTableEventID = [String]()
    var isAddEvent: Bool = false
    var isInviteUser: Bool = false
    var isUserInGroup: Bool = false
    var userList = [String]()
    var userIdList = [String]()
    var userIdList_ingroup_and_invited = [String]()
    var groupInfo: GroupInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.delegate = self
        eventTableView.dataSource = self
        // to check if the user is in the group
        refHandle = ref?.child("Users").child(myUserID).child("Groups").observe(.value, with: { (snapshot) in
            if(snapshot.childrenCount > 0){
                for groups in snapshot.children.allObjects as! [DataSnapshot] {
                    if groups.key == self.groupId {
                        self.isUserInGroup = true
                    }
                }
            }
        })
        
        let currentuserID = Auth.auth().currentUser?.uid
        self.ref?.child("Groups").child(groupId!).child("users").observe(.value, with: { snapshot in
            if snapshot.hasChild(currentuserID!){
                self.joinGroupButton.isHidden = true
            } else {
                self.joinGroupButton.isHidden = false
            }
        })
        
        refHandle = self.ref?.child("Groups").child(groupId).observe(DataEventType.value, with: { (snapshot) in
            self.groupTableContents[1].removeAll()
            self.userIdList_ingroup_and_invited.removeAll()
            self.groupTableEventID.removeAll()
            self.userList.removeAll()
            self.userIdList.removeAll()
            self.userIdList_ingroup_and_invited.removeAll()
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
                        self.groupTableEventID.append(myGroupEvents.sessionId ?? "")
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
                                self.userIdList.append(userSnapshot.key)
                            }
                            self.userIdList_ingroup_and_invited.append(userSnapshot.key)
                        }
                    }
                }
                // Set value with database info
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
        if isAddEvent == true{
            let destination = segue.destination as! AddEventViewController
            destination.groupID = self.groupId
            isAddEvent = false
        }
        else if isInviteUser == true {
            let destination = segue.destination as! InviteFriendsViewController
            destination.groupId = self.groupId
            destination.usersInCurrentGroup = self.userIdList_ingroup_and_invited
            isInviteUser = false
        }
        else{
            var indexPath = self.eventTableView.indexPathForSelectedRow!
            if(indexPath.section == 0){
                let destination = segue.destination as! GroupMemberListTableViewController
                destination.navigationItem.title = groupTableContents[indexPath.section][indexPath.row]
                destination.memberList = userList
                destination.memberIdList = userIdList
            }
            else {
                /*sends event id to the user events view controller so we can see which event to display*/
                let destination = segue.destination as! UserEventsViewController
                destination.navigationItem.title = groupTableContents[indexPath.section][indexPath.row]
                destination.eventId = groupTableEventID[indexPath.row]
            }
        }
    }
    
    // Setup header in each section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        /*this adds a button in the section header on the right side so that a user can be redirected to add an event and invite button*/
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        let label = UILabel()
        label.text = groupTableSections[section]
        label.frame = CGRect(x: 10, y: 0, width: 100, height: 22)
        headerView.addSubview(label)
        if isUserInGroup == true {
            // let image = UIImage(named: "plus")
            let button = UIButton()
            if section == 0 {
                button.frame = CGRect(x: view.bounds.maxX - 55, y: 0, width: 50, height: 22)
                button.setTitle("Invite", for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.addTarget(self, action: #selector(inviteButtonPressed), for: .touchUpInside)
            }
            else {
                button.frame = CGRect(x: view.bounds.maxX - 105, y: 0, width: 100, height: 22)
                button.setTitle("Add Event", for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.addTarget(self, action: #selector(addEventsButtonPressed), for: .touchUpInside)
            }
            button.layer.borderWidth = 1
            button.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
            button.showsTouchWhenHighlighted = true
            headerView.addSubview(button)
        }
        return headerView
    }
    @objc func inviteButtonPressed(sender: UIButton!){
        /*performs segue when the invite button is pressed*/
        isInviteUser = true
        performSegue(withIdentifier: "inviteFriends", sender: self)
    }
    @objc func addEventsButtonPressed(sender: UIButton!){
        /*performs a segue to the add event page once the button to add an event is pressed*/
        isAddEvent = true;
        performSegue(withIdentifier: "AddEvents" , sender: self)
    }
    // Set height of header in section
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    // clicking the join group button will now allow put the group as one of the user's groups
    func joinThisGroup() {
        let currentuserID = Auth.auth().currentUser?.uid
        self.ref?.child("Users").child(currentuserID!).child("name").observe(.value, with: { snapshot in
            guard let userName = snapshot.value as? String else {
                return
            }
            let currentgroup = self.groupId as String
            let post = ["/Groups/\(currentgroup)/users/\(currentuserID!)":  ["joined": 1, "name" : userName],
                        "/Users/\(currentuserID!)/Groups/\(currentgroup)": ["chatid": self.groupInfo?.chatId, "grouptype": self.groupInfo?.groupType, "name": self.groupInfo?.name]] as [String : Any]
            self.ref?.updateChildValues(post)
        })
    }
}
