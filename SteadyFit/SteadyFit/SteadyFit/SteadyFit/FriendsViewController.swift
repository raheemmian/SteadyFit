//
//  FriendsViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-10-23.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Raheem Mian, Yimin Long
//  List of Changes: Work in Progress
//  Created table, array for friend list, added emergency button and GPS related code
//
//  Friends View controller displays all of the users friends in a list, and clicking on their friends leads to their friends personal profile.
//  The emergency button is implemented to obtain iPhone's GPS location and bring up iPhone's messaging app with a default message.
//

import UIKit
import MessageUI
import CoreLocation
import FirebaseAuth
import FirebaseDatabase

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate{
    
    var ref:DatabaseReference?
    var refHandle:DatabaseHandle?
    let currentuserID = (Auth.auth().currentUser?.uid)!
    var currentUserEmergencyNum: String?
    
    let friendList = ["Friend A", "Friend B", "Friend C", "Friend D"]
    @IBOutlet weak var friendTableView: UITableView!
    var locationManager = CLLocationManager()
    @IBAction func EmergencyButton(_ sender: Any) {
        sendText()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        /*initializing the tables and locations*/
        friendTableView.tableFooterView = UIView(frame: .zero)
        friendTableView.delegate = self
        friendTableView.dataSource = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        ref = Database.database().reference()
        self.ref!.child("Users").child(currentuserID).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let userDictionary = snapshot.value as? [String: AnyObject]
            print (snapshot)
            
            if userDictionary != nil{
                self.currentUserEmergencyNum = userDictionary!["emergencycontact"] as? String
                print(self.currentUserEmergencyNum)
            }
            
        })
        
        
    }
    
    //func getEmergencyContact(){
    //var emergencyContact =
    
    //}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        /*return the number of rows in the table*/
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        /*return the tablecell name*/
        let tableCell = friendTableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        tableCell.textLabel?.text = friendList[indexPath.row]
        return tableCell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*perform the segue to the friends Profile*/
        performSegue(withIdentifier: "friends", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*provide the title for the navigation bar based on the row selected*/
        var indexPath = self.friendTableView.indexPathForSelectedRow!
        let post = segue.destination as! UserProfileViewController
        post.navigationItem.title = friendList[indexPath.row]
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        /*The message controller is dismissed once the message is either sent or the cancel button is pressed. It segues back
         to the screen where the emergency button was pressed*/
        controller.dismiss(animated: true, completion: nil)
    }
    
    func sendText() {
        /*This function is for bringing up the messsage controller once the emergency button is pressed
         and automatically putting a custom message and current location*/
        let composeVC = MFMessageComposeViewController()
        if(CLLocationManager.locationServicesEnabled()){
            /*get the coordinates for the person and put into a google link */
            locationManager.startUpdatingLocation()
            let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
            composeVC.body = "I need help! This is my current location: " + "http://maps.google.com/maps?q=\(locValue.latitude),\(locValue.longitude)&ll=\(locValue.latitude),\(locValue.longitude)&z=17"
        }
        else{
            /*if location services is not enabled*/
            composeVC.body = "I need help!"
        }
        composeVC.messageComposeDelegate = self
        composeVC.recipients = [self.currentUserEmergencyNum] as? [String]
        if (MFMessageComposeViewController.canSendText()) {
            /*if the message view controller is available then send the text*/
            self.present(composeVC, animated: true, completion: nil)
        } else {
            /*error message - cannot send text on simulator have to use a apple mobile device*/
            print("Can't send messages.")
        }
    }}
