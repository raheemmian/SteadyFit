//
//  HomeViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-10-23.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Raheem Mian, Akshay Kumar, Dickson Chum
//  List of Changes: added labels, table and arrays for table, created segues for table view, implemented to obtain GPS coordinate from device and bring up iPhone Messages with default message.
//  Edited by: Alexa Chen on 2018-11-19
//  List of Changes: populated home page with current user info and user events. Also set up necessary activity data for activity tracker histogram
//  HomeViewController.swift is connected to the first Home Screen of the UI, which shows the User's profile, activity tracker, events and emergency button.
//  The emergency button is implemented to obtain iPhone's GPS location and bring up iPhone's messaging app with a default message.
//  Make sure you test the emergency button when you download the app on your mobile device

import UIKit
import Foundation
import MessageUI
import MapKit
import CoreLocation
import Firebase

class HomeViewController: EmergencyButtonViewController, UITableViewDataSource, UITableViewDelegate{
    var personalref:DatabaseReference?
    var eventIDs = [String]()
    let personalcurrentuserID = (Auth.auth().currentUser?.uid)!
    var activity_day: [String: Int] = [:]
    
    let homeTableSections = ["Activity Tracker", "Events"]
    var homeTableContents = [ ["Histogram"] , ["Event A", "Event B", "Event C"]]
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePictureImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        /*initializing the tables and the locations*/
        myTableView.tableFooterView = UIView(frame: .zero)
        myTableView.delegate = self
        myTableView.dataSource = self
        profilePictureImage.layer.cornerRadius = profilePictureImage.frame.size.width / 2
        profilePictureImage.clipsToBounds = true
        
        personalref = Database.database().reference()
        self.personalref?.child("Users/\(personalcurrentuserID)").observe(DataEventType.value, with: {
            (userSnapshot) in
            if userSnapshot.value != nil{
                let userDictionary = userSnapshot.value as? [String: AnyObject]
                self.name.text = userDictionary!["name"] as? String
                self.city.text = userDictionary!["city"] as? String
            }
        })
        self.personalref?.child("Activities_Events").queryOrdered(byChild: "date").observe(DataEventType.value, with: {
            (snapshot) in
            self.eventIDs.removeAll()
            self.homeTableContents[1].removeAll()
            var childIndex = 0
            
            print(snapshot)
                
            for sessionSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                childIndex += 1
                if childIndex == 1 {
                    guard let oldestActivityDictionary = sessionSnapshot.value as? [String:AnyObject] else {continue}
                    guard let tempOldestDate = oldestActivityDictionary["date"] as? String else {continue}
                    self.createActivityArrays(oldestDate: tempOldestDate)
                }
                
                if sessionSnapshot.childSnapshot(forPath: "Participants/\(self.personalcurrentuserID)").value != nil{
                    guard let sessionDictionary = sessionSnapshot.value as? [String: AnyObject] else {continue}
                    guard let isPersonal = sessionDictionary["isPersonal"] as? Int else {continue}
                    if isPersonal == 0{
                        self.homeTableContents[1].append((sessionDictionary["event_name"] as? String)!)
                        self.eventIDs.append(sessionSnapshot.key)
                    }
                    guard let tempEventDate = sessionDictionary["date"] as? String else {continue}
                    guard let tempEventDuration = sessionDictionary["duration_minute"] as? String else {continue}
                    self.appendActivity(key: tempEventDate, value: Int(tempEventDuration)!)
                }
            }
            print (self.activity_day)
            DispatchQueue.main.async() {
                self.myTableView.reloadData()
            }
        })
    }
    /*-----------------------------------Location-------------------------------------------------------------*/
    /*-----------------------------------Table----------------------------------------------------------------*/
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeTableSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        /*return table header name*/
        return homeTableSections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*return the number of rows in for a section*/
        return homeTableContents[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*return the name for the cell*/
        let cell  = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for:  indexPath)
        cell.textLabel?.text = homeTableContents[indexPath.section][indexPath.row]
        return cell
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    /*Go either to the event view controller or the histogram view controller*/
        performSegue(withIdentifier: homeTableSections[indexPath.section], sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*This function provides the header for the navigation bar in the histogram view controller and the
         events view controller based on the name of the cell pressed*/
        var indexPath = self.myTableView.indexPathForSelectedRow!
        if(indexPath.section == 0){
            let destination = segue.destination as! HistogramViewController
            destination.navigationItem.title = homeTableContents[indexPath.section][indexPath.row]
            destination.histogram_data = activity_day
        }
        else{
            let destination = segue.destination as! UserEventsViewController
            destination.navigationItem.title = homeTableContents[indexPath.section][indexPath.row]
            destination.eventId = eventIDs[indexPath.row] // Raheem, if you have a variable called eventId in the UserEventsViewController, just uncomment this line and it will set the variable to the correct value
            
        }
    }
    
   /* func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: tableView.frame.width - 30, height: 50)
        button.setTitle("Open", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: Selector(("SegueToEvents:")), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
        return view
    }
    func SegueToEvents(sender: AnyObject){
        print("Hi")
    }*/
    
    func appendActivity(key: String, value: Int){
        
        let dateFormatter = DateFormatter()
        if key.count > 10 {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        }
        else{
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        let inputDate = dateFormatter.date(from: key)
        
        if inputDate! <= Date(){
            var day_key:String = key
            if key.count > 10 {
                day_key.removeLast(6)
            }
            let day_value = (activity_day[day_key] ?? 0) + value
            activity_day[day_key] = day_value
        }
    }
    
    func createActivityArrays(oldestDate :String){
        activity_day.removeAll()
        
        var oldestDate_formatted:String = oldestDate
        if oldestDate.count > 10 {
            oldestDate_formatted.removeLast(6)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let oldest = dateFormatter.date(from: oldestDate_formatted)
        let today = Date()
        let components = Calendar.current.dateComponents([.day], from: oldest!, to: today)
        let activity_day_count = (components.day ?? 0)
        
        for i in 0...activity_day_count{
            let tempDate:Date = Calendar.current.date(byAdding: .day, value: i, to: oldest!)!
            let tempDateString = dateFormatter.string(from: tempDate)
            activity_day[tempDateString] = 0
        }
        print (activity_day)
    }

}
