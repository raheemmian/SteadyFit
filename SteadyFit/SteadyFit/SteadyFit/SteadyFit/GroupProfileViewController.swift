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

class GroupProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var groupDesc: UILabel!
    @IBOutlet weak var groupDescInfo: UILabel!
    @IBOutlet weak var activityLevel: UILabel!
    @IBOutlet weak var activityLevelInfo: UILabel!
    @IBOutlet weak var groupStatus: UILabel!
    @IBOutlet weak var groupStatusInfo: UILabel!
    @IBOutlet weak var eventTableView: UITableView!
    
    @IBAction func emergencyButton(_ sender: UIButton) {sendText()}
    var ref:DatabaseReference? = Database.database().reference()
    var refHandle:DatabaseHandle?
    var locationManager = CLLocationManager()
    var groupID : String!
    var groupTableSections = ["Members", "Events"]
    var groupTableContents = [["More"], ["A Event on Jan 1, 2018", "B Event on Feb 1, 2018", "C Event on Mar 1, 2018"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.delegate = self
        eventTableView.dataSource = self
        
        groupID = "Group2"
        
        //let currentuserID = Auth.auth().currentUser?.uid
        refHandle = self.ref?.child("Groups").child(groupID).observe(DataEventType.value, with: { (snapshot) in
            
            if let groupInfo = snapshot.value as? [String: AnyObject]{
                let myGroupInfo = GroupInfo()
                myGroupInfo.activityLevel = groupInfo["activitylevel"] as?String
                myGroupInfo.chatId = groupInfo["chatid"] as?String
                myGroupInfo.groupDescription = groupInfo["description"] as?String
                myGroupInfo.events = groupInfo["events"] as?String
                myGroupInfo.groupType = groupInfo["grouptype"] as?String
                myGroupInfo.location = groupInfo["location"] as?String
                myGroupInfo.name = groupInfo["location"] as?String
                myGroupInfo.users = groupInfo["users"] as?String
                
                //if (groupInfo["users"] != nil){
                //}
                
                //print(myGroupInfo.events)
                //print(myGroupInfo.chatId)
                //print(myGroupInfo.users)
                //print(myGroupInfo.location)
                
                self.groupDesc.text = "Group Description:"
                self.groupDescInfo.text = myGroupInfo.groupDescription
                self.activityLevel.text = "Activity Level:"
                self.activityLevelInfo.text = myGroupInfo.activityLevel
                self.groupStatus.text = "Group Status:"
                self.groupStatusInfo.text = myGroupInfo.groupType
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
        var indexPath = self.eventTableView.indexPathForSelectedRow!
        if(indexPath.section == 0){
            let post = segue.destination as! GroupMemberListTableViewController
            post.navigationItem.title = groupTableContents[indexPath.section][indexPath.row]
        }
        else{
            let post = segue.destination as! UserEventsViewController
            post.navigationItem.title = groupTableContents[indexPath.section][indexPath.row]
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func sendText() {
        let composeVC = MFMessageComposeViewController()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.startUpdatingLocation()
            let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
            composeVC.body = "I need help! This is my current location: " + "http://maps.google.com/maps?q=\(locValue.latitude),\(locValue.longitude)&ll=\(locValue.latitude),\(locValue.longitude)&z=17"
        }
        else{
            composeVC.body = "I need help!"
        }
        composeVC.messageComposeDelegate = self
        composeVC.recipients = ["7788823644"]
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
}
