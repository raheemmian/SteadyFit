//
//  UserEventsViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-11-03.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Raheem Mian
//  List of Changes: N/A - Work in Progress
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class UserEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var eventsTableView: UITableView!
    /*------------------database stuff-----------*/
    var ref:DatabaseReference? = Database.database().reference()
    var refHandle:DatabaseHandle?
    var groupID = ""
    var myUserID = (Auth.auth().currentUser?.uid)!
    var myUserName: String = ""
    var eventID = "-LRYLUmfAD3YVboXHcbG"
    /*-----------------------------*/
    var eventName: String = ""
    var location:String = "Vancouver"
    var date:String = "September 30 2018"
    var startTime: String = "12:00"
    var endTime: String = "3:00"
    var participants: String = ""
    var duration: String = " - "
    var eventDescription = ["Location: " , "Date: ", "Duration: "]
    var eventInfo = [EventModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        descriptionTextView.isEditable = false
        self.duration = startTime + " - " + endTime
        self.descriptionTextView.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        
        ref?.child("Activities_Events").observe(DataEventType.value, with: { (snapshot) in
            print(snapshot.value)
            print(snapshot.childrenCount)
            if snapshot.childrenCount > 0 {
                self.eventInfo.removeAll()
                for events in snapshot.children.allObjects as! [DataSnapshot]{
                    let eventObject = events.value as? [String: AnyObject]
                    let eventNameObj = eventObject?["event_name"]
                    let locationObj = eventObject?["location"]
                    let dateObj = eventObject?["date"]
                  //  let participants = eventObject[""]
                    let durationObj = eventObject?["duration_minute"]
                    let event = EventModel(eventName: eventNameObj as! String?, location: locationObj as! String?, date: dateObj as! String? ?? "nill", duration: durationObj as! String?)
                    self.eventInfo.append(event)
                }
                
            }
        })
        
      //  self.date  = eventInfo[0].date!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*Location, Date, Duration*/
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*return the name for the cell*/
        let tableCell  = tableView.dequeueReusableCell(withIdentifier: "EventDescriptionTableCell", for:  indexPath)
        tableCell.layer.borderWidth = 0.5
        if indexPath.row == 0{
            tableCell.textLabel?.text = eventDescription[indexPath.row] + location
        }
        else if(indexPath.row == 1){
            tableCell.textLabel?.text = eventDescription[indexPath.row] + date
        }
        else if indexPath.row == 2{
            tableCell.textLabel?.text = eventDescription[indexPath.row] + duration
        }
        return tableCell
    }
}

class EventModel {
    var eventName: String?
    var location: String?
    var date:String?
    //var participants: String?
    var duration: String?
    init(eventName:String?, location:String?, date:String, /*participants:String,*/ duration:String?){
        self.eventName = eventName
        self.location = location
        self.date = date
        //self.participants = participants
        self.duration = duration
    }
}
