//
//  FriendsViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-10-23.
//  Copyright © 2018 Daycar. All rights reserved.
//Friends View controller displays all of the users friends in a list, and clicking on their friends leads to their friends personal profile.
//  The emergency button is implemented to obtain iPhone's GPS location and bring up iPhone's messaging app with a default message.

import UIKit
import MessageUI
import CoreLocation

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate{
    
    let friendList = ["Friend A", "Friend B", "Friend C", "Friend D"]
    @IBOutlet weak var friendTableView: UITableView!
    var locationManager = CLLocationManager()
    @IBAction func EmergencyButton(_ sender: Any) {sendText()}
    override func viewDidLoad() {
        super.viewDidLoad()
        friendTableView.tableFooterView = UIView(frame: .zero)
        friendTableView.delegate = self
        friendTableView.dataSource = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let tableCell = friendTableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        tableCell.textLabel?.text = friendList[indexPath.row]
        return tableCell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "friends", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = self.friendTableView.indexPathForSelectedRow!
            let post = segue.destination as! FriendProfileViewController
            post.navigationItem.title = friendList[indexPath.row]
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
    }}
