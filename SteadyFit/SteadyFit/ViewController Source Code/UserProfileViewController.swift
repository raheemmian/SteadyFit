//
//  UserProfileViewController.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-11-03.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Dickson Chum
//  Added labels and image view, added emergency button and GPS related code, hide friend request button when the profile is current user
//  Fixed gender section
//
//  Edited by: Calvin Liu
//  Friend's profile now load from the database rather than being hardcoded
//
//  UserProfileViewController.swift is linked to an User Profile Page, which shows the user's information.
//  The emergency button is implemented to obtain iPhone's GPS location and bring up iPhone's messaging app with a default message.
//

import UIKit
import MessageUI
import CoreLocation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate {
    // Variables and IB objects declaration
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    var locationManager = CLLocationManager()
    @IBAction func emergencyButton(_ sender: Any) {sendText()}
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var sendFriendRequestButton: UIButton!
    
    @IBAction func sendFriendRequest(_ sender: Any) {addFriend()}
    var ref:DatabaseReference? = Database.database().reference()
    var refHandle:DatabaseHandle?
    var friendUserId : String = ""
    var newGroupId : Int = 0
    let friendTableSections = ["Gender", "Birthday", "Bio"]
    var friendTableContents: [String] = ["", "", ""]
    let currentuserID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2
        profilePic.clipsToBounds = true
        
        self.ref?.child("Users").child(self.currentuserID!).child("Friends").observeSingleEvent(of: .value, with: {(snapshot) in
            if (snapshot.hasChild(self.friendUserId) || self.friendUserId == self.currentuserID) {
                self.sendFriendRequestButton.isHidden = true
            } else {
                self.sendFriendRequestButton.isHidden = false
            }
        })
        
        // load the friend profile from database
        self.ref?.child("Users").child(friendUserId).observe(DataEventType.value, with: {(userSnapshot) in
            if userSnapshot.value != nil{
                let userDictionary = userSnapshot.value as? [String: AnyObject]
                self.name.text = userDictionary!["name"] as? String
                self.location.text = userDictionary!["city"] as? String
                let friendGender = userDictionary!["gender"] as? String
                
                self.friendTableContents.removeAll()
                if (friendGender == "Male"){
                    self.friendTableContents.append("Male")
                }
                else if (friendGender == "Female"){
                    self.friendTableContents.append("Female")
                }
                else {
                    self.friendTableContents.append("Prefer not to say")
                }
                
                self.friendTableContents.append((userDictionary!["birthdate"] as? String)!)
                self.friendTableContents.append((userDictionary!["description"] as? String)!)
                
                // load profile
                if let imageURL = userDictionary!["profilepic"] as? String{
                    let url = URL(string: imageURL)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        DispatchQueue.main.async() {
                            self.profilePic?.image = UIImage(data:data!)
                        }
                    }).resume()
                }
                DispatchQueue.main.async{
                    self.myTableView.reloadData()
                }
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return friendTableSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendTableSections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendTableCell", for:  indexPath)
        cell.textLabel?.text = friendTableContents[indexPath.section]
        return cell
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
    
    // will generate nodes on the database for friend request when the send friend request is clicked
    func addFriend() {
        self.ref?.child("Users").child(currentuserID!).child("name").observe(.value, with: { mysnapshot in
            guard let myName = mysnapshot.value as? String else {return}
            self.ref?.child("Users").child(self.friendUserId).child("name").observe(.value, with: { friendsnapshot in
                guard let friendName = friendsnapshot.value as? String else {return}
                
                let key = "Group" + self.currentuserID! + self.friendUserId
                let chatId = "Chat" + self.currentuserID! + self.friendUserId
                let groupType = "Friends"
                if (self.currentuserID != self.friendUserId){
                    let post = [ "/Groups/\(key)/chatid": chatId,
                                 "/Groups/\(key)/grouptype": groupType,
                                 "/Groups/\(key)/user1": [self.currentuserID: ["joined": 1, "name": myName]],
                                 "/Groups/\(key)/user2": [self.friendUserId: ["joined": 0, "name": friendName]],
                                 "/Chats/\(chatId)/groupID" : key] as [String : Any]
                    self.ref?.updateChildValues(post)
                }
            })
        })
        self.sendFriendRequestButton.isHidden = true
    }
}
