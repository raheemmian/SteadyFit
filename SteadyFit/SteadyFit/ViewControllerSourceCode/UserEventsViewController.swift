//
//  UserEventsViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-11-03.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//
//  Edited by: Raheem Mian
//  grabs the information from the database about the event
//  and displays it for the user
//  also redirects to the participants view controller to show the paticipants of the events
//
//  Edited by: Akshay Kumar (30/11/2018)
//  Added support for notfication event creation upon joining an event
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import UserNotifications

// EventModel structure
class EventModel {
    var eventName: String
    var location: String
    var date: String
    var duration: String
    var description: String
    init(){
        eventName = ""
        location = ""
        date = ""
        duration = ""
        description = ""
    }
}

class UserEventsViewController: EmergencyButtonViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var goingButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    /*------------------database stuff-----------*/
    var ref:DatabaseReference? = Database.database().reference()
    var refHandle:DatabaseHandle?
    var myUserID = (Auth.auth().currentUser?.uid)!
    var myUserName: String = ""
    var eventId:String = ""
    var participantsCheckArr = [String]()
    var going: Bool = false
    /*-----------------------------*/
    let sectionHeader = ["Event Information" , "Participants"]
    let sectionContent = [["Location: ", "Date: ", "Duration: "], ["Event Members"]]
    let myEventInfo = EventModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        descriptionTextView.isEditable = false
        goingButton.layer.borderWidth = 1
        goingButton.layer.borderColor = UIColor.blue.cgColor
        descriptionLabel.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        if going == true{
            self.goingButton.isHidden = true
        }
        /*grabs the users username from the database
         grabs the event information
         and grabs the participants and checks if the user is going
         and if they are then the going button is not displayed*/
        ref?.child("Users").child(myUserID).child("name").observeSingleEvent(of: .value, with: {(snapshot) in
            self.myUserName = (snapshot.value as? String)!
        })
        ref?.child("Activities_Events").child(eventId).observe(DataEventType.value, with: { (snapshot) in
            if let eventInfo = snapshot.value as? [String: AnyObject]{
                self.myEventInfo.date = eventInfo["date"] as! String
                self.myEventInfo.duration = eventInfo["duration_minute"] as! String
                self.myEventInfo.eventName = eventInfo["event_name"] as! String
                self.myEventInfo.location = eventInfo["location"] as! String
                self.myEventInfo.description = eventInfo["description"] as! String
                self.descriptionTextView.text = self.myEventInfo.description
                self.navigationItem.title = self.myEventInfo.eventName
                DispatchQueue.main.async() {
                    self.eventsTableView.reloadData()
                }
            }
        })
        refHandle = ref?.child("Activities_Events").child(eventId).child("Participants").observe(.value, with: { (snapshot) in
            if(snapshot.childrenCount > 0){
                for participant in snapshot.children.allObjects as! [DataSnapshot] {
                    let nameObject = (participant.value as? [String: AnyObject])!
                    let name = nameObject["name"] as! String
                    if name == self.myUserName {
                        self.going = true
                        self.goingButton.isHidden = true
                        break
                    }
                }
            }
        })
    }
    
    @IBAction func goingButtonAction(_ sender: Any) {
        /*when this buttn is pressed, hide the button and then add the current user to the participant
         to the event in the database*/
        goingButton.isHidden = true
        let newParticipantPost = ["name": myUserName] as [String: Any]
        let addParticipant = ["/Activities_Events/\(eventId)/Participants/\(myUserID)/" : newParticipantPost]
        ref?.updateChildValues(addParticipant)
        
        //Creating a request for a notification
        //Checking if notificaitons are turned on in settings using a boolean varibale
        if(NotificationBool.shared.state == true)
        {
        //Obtaining Authorization again in case
        UNUserNotificationCenter.current().requestAuthorization(options:
        [.alert, .badge, .sound]) { (granted, error) in
        }
        
        //Creating Notification content
        let content = UNMutableNotificationContent()
        content.title = self.myEventInfo.eventName
        content.body = self.myEventInfo.description
        content.sound = UNNotificationSound.default
        
        //Date string
        let dstring = self.myEventInfo.date
        
        //Convert date from String to Date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: dstring)
        
        //Subtract an hour from the Date so notfication arrives an hour early
        let datesubhour = date!.addingTimeInterval(-3600)
        
        //Break date into components so Notification can be scheduled by iOS Notfication centre
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: datesubhour)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        //use the trigger below to show a notfication in 5 seconds, for testing purponses. (comment trigger above)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //Each Notification needs a unique String ID, I chose it to be event name
        let identifier = self.myEventInfo.eventName
        
        //Creating and sending requests to iOS notification centre
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        /*return table header name*/
        return sectionHeader[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*Location, Date, Duration*/
        return sectionContent[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*return the name for the cell*/
        let tableCell  = tableView.dequeueReusableCell(withIdentifier: "EventDescriptionTableCell", for:  indexPath)
        //tableCell.layer.borderWidth = 0.5
        if indexPath.row == 0 && indexPath.section == 0{
            tableCell.textLabel?.text = sectionContent[0][indexPath.row] + self.myEventInfo.location
        }
        else if(indexPath.row == 1){
            tableCell.textLabel?.text = sectionContent[0][indexPath.row] + self.myEventInfo.date
        }
        else if indexPath.row == 2{
            tableCell.textLabel?.text = sectionContent[0][indexPath.row] + self.myEventInfo.duration + " minutes"
        }
        else{
            tableCell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
            tableCell.accessoryType = .disclosureIndicator
        }
        return tableCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 1 {
            performSegue(withIdentifier: sectionHeader[1] , sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ParticipantsViewController
        destination.eventId = eventId
    }
}
