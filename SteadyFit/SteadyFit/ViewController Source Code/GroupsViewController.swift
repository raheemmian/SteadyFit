//
//  GroupsViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-10-23.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//
//  Edited by: Dickson Chum
//  List of Changes: added segmented control, table and arrays for table, created segues for table view
//  added database automatic population for user "My Group"
//
//  Edited by: Alexa Chen on 2018-11-14
//  List of Changes: improved recommendation algorithm
//
//  Resolved Bugs:
//  When group node changes in database, the view append groups, hence create duplicate groups.
//  When the list of groups become too long, there is no scrolling implemented in the page
//
//  GroupsViewController.swift is connected to Groups section of the UI, which shows user joined groups and recommmented groups by toggling on segmented control.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation
import MessageUI

class GroupsViewController: EmergencyButtonViewController, UITableViewDataSource, UITableViewDelegate {
    var queryMyGroups = [UserGroup]()
    var suggestedGroups = [UserGroup]()
    var sameProvinceGroups = [UserGroup]()
    var sameActivityLevelGroups = [UserGroup]()
    var restoftheGroups = [UserGroup]()
    var p: Int = 0
    var isAddButtonPressed: Bool = false
    var sectionForGroup = ["Groups"]
    var ref:DatabaseReference?
    var refHandle:DatabaseHandle?
    var groupsHandle:DatabaseHandle?
    var currentUserCity: String?
    var currentUserActivityLevel: String?

    @IBOutlet weak var groupTableView: UITableView!
    @IBAction func groupSegmentedControl(_ sender: UISegmentedControl) {
        p = sender.selectedSegmentIndex
        groupTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.tableFooterView = UIView(frame: .zero)
    
        //  Database initialization
        ref = Database.database().reference()
        
        //  Firebase fetch start
        //  Get current authenticated user
        let currentuserID = Auth.auth().currentUser?.uid
        refHandle = ref?.child("Users").child(currentuserID!).observe(DataEventType.value, with: {
            (snapshot) in
            // Clear group lists
            self.queryMyGroups.removeAll()
            
            // get user groups
            for rest in snapshot.childSnapshot(forPath: "Groups").children.allObjects as! [DataSnapshot]{
                guard let dictionary = rest.value as? [String: AnyObject] else {continue}
                let myGroup = UserGroup()
                myGroup.groupID = rest.key
                myGroup.name = dictionary["name"] as?String
                myGroup.chatid = dictionary["chatid"] as?String
                myGroup.grouptype = dictionary["GroupType"] as?String
                if myGroup.grouptype != "Friends"{
                    self.queryMyGroups.append(myGroup)
                }
            }
            // Get user city and activity level for recommending algorithm
            if let dictionary2 = snapshot.value as? [String: AnyObject]{
                let myCity = dictionary2["city"] as?String
                let myActivityLevel = dictionary2["activitylevel"] as?String
                if myCity != nil{
                    self.currentUserCity = myCity
                }
                if myActivityLevel != nil{
                    self.currentUserActivityLevel = myActivityLevel
                }
            }
            
            //  Recommend user with groups from the same location,
            self.groupsHandle = self.ref!.child("Groups").queryOrdered(byChild: "grouptype").queryEqual(toValue:"Public").observe(DataEventType.value, with: {
                (groupsnapshot) in
                self.suggestedGroups.removeAll()
                self.sameProvinceGroups.removeAll()
                self.sameActivityLevelGroups.removeAll()
                self.restoftheGroups.removeAll()
                //check if any of the groups are in user's groups, if yes append
                for rest in groupsnapshot.children.allObjects as! [DataSnapshot] {
                    guard let Groupdictionary = rest.value as? [String: AnyObject] else {continue}
                    let checkUserdictionary = rest.childSnapshot(forPath: "users").childSnapshot(forPath: currentuserID!).value as? [String:AnyObject]
                    let myUserJoined = checkUserdictionary?["joined"] as?Int
                    let tempGroup = UserGroup();
                    // check if user is already in group or requested to join
                    if (myUserJoined != nil &&  myUserJoined == 0) || myUserJoined == nil
                    {
                        tempGroup.name = Groupdictionary["name"] as?String ?? "NA"
                        tempGroup.groupID = rest.key
                        tempGroup.chatid = Groupdictionary["chatid"] as?String ?? "NA"
                        tempGroup.grouptype = Groupdictionary["grouptype"] as?String
                        let levelString = Groupdictionary["activitylevel"] as?String
                        tempGroup.setActivityLevel(level: levelString!)
                        tempGroup.city = Groupdictionary["location"] as?String
                        if tempGroup.city == self.currentUserCity{
                            self.sameProvinceGroups.append(tempGroup)
                        }
                        else if tempGroup.activitylevel == self.currentUserActivityLevel {
                            self.sameActivityLevelGroups.append(tempGroup)
                        }
                        else{
                            self.restoftheGroups.append(tempGroup)
                        }
                    }
                }
                self.sameProvinceGroups.sort(by: { $0.activityLevelInt! < $1.activityLevelInt!})
                self.sameActivityLevelGroups.sort(by: { $0.city!.compare($1.city!) == .orderedAscending })
                self.restoftheGroups.sort(by: { ($0.city! == $1.city!) ? ($0.activityLevelInt! < $1.activityLevelInt!) : ($0.city!.compare($1.city!) == .orderedAscending) })
                self.suggestedGroups.append(contentsOf: self.sameProvinceGroups)
                self.suggestedGroups.append(contentsOf: self.sameActivityLevelGroups)
                self.suggestedGroups.append(contentsOf: self.restoftheGroups)
                DispatchQueue.main.async{
                    self.groupTableView.reloadData()
                }
                
            })
        })
//        p = 0
    }
    
    // Return number of section
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionForGroup.count
    }
    // Return section title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionForGroup[section]
    }
    // Return number of contents of each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            var returnValue = 0
            switch (p) {
            case 0:
                returnValue = queryMyGroups.count
                break
            case 1:
                returnValue = suggestedGroups.count
                break
            default:
                break
            }
            return returnValue
    }
    // Return contents of each section
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupTableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
            switch (p) {
            case 0:
                cell.textLabel?.text = queryMyGroups[indexPath.row].name
                break
            case 1:
                cell.textLabel?.text = suggestedGroups[indexPath.row].name
                break
            default:
                break
            }
        return cell
    }
    // Perform segue when row is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showGroupDetail", sender: self)
        groupTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Checks if the add button is pressed otherwise prepares different segues based on
        // page and row.
        if isAddButtonPressed == false {
            var indexPath = self.groupTableView.indexPathForSelectedRow!
            switch (p) {
            case 0:
                let destination = segue.destination as! GroupProfileViewController
                destination.navigationItem.title = queryMyGroups[indexPath.row].name
                destination.groupId = queryMyGroups[indexPath.row].groupID
                break
            case 1:
                let destination = segue.destination as! GroupProfileViewController
                destination.navigationItem.title = suggestedGroups[indexPath.row].name
                destination.groupId = suggestedGroups[indexPath.row].groupID
                break
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Add a button in the section header on the right side so that a user can be redirected to add a private group
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        let label = UILabel()
        label.text = sectionForGroup[section]
        label.frame = CGRect(x: 10, y: 0, width: 100, height: 22)
        headerView.addSubview(label)
        if p == 0 {
            let button = UIButton()
            button.frame = CGRect(x: view.bounds.maxX - 55, y: 0, width: 50, height: 22)
            button.setTitle("Add", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(AddButtonPressed), for: .touchUpInside)
            button.layer.borderWidth = 1
            button.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
            button.showsTouchWhenHighlighted = true
            headerView.addSubview(button)
        }
        return headerView
    }
    
    @objc func AddButtonPressed() {
        // Goes to the tempplate page for adding a private group
        isAddButtonPressed = true
        performSegue(withIdentifier: "createPrivateGroup", sender: self)
        isAddButtonPressed = false
    }
}
