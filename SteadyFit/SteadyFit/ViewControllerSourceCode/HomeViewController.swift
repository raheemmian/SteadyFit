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
//
//  Edited by: Alexa Chen on 2018-11-19
//  List of Changes: populated home page with current user info and user events. Also set up necessary activity data for activity tracker histogram
//
//  HomeViewController.swift is connected to the first Home Screen of the UI, which shows the User's profile, activity tracker, events and emergency button.
//

import UIKit
import Foundation
import MessageUI
import MapKit
import CoreLocation
import Firebase
import FirebaseStorage

class HomeViewController: EmergencyButtonViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // Variables declaration
    var ref:DatabaseReference?
    var eventIDs = [String]()
    let currentuserID = (Auth.auth().currentUser?.uid)!
    var activity_day: [String: Int] = [:]
    let storageRef = Storage.storage().reference()
    let homeTableSections = ["Activity Tracker", "Events"]
    var homeTableContents = [ ["Histogram"] , ["", "", ""]]
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePictureImage: UIImageView!
    
    // Initializing the tables and request location permission
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        myTableView.tableFooterView = UIView(frame: .zero)
        myTableView.delegate = self
        myTableView.dataSource = self
        profilePictureImage.layer.cornerRadius = profilePictureImage.frame.size.width / 2
        profilePictureImage.clipsToBounds = true
        ref = Database.database().reference()
        self.ref?.child("Users/\(currentuserID)").observe(DataEventType.value, with: {
            (userSnapshot) in
            if userSnapshot.value != nil{
                let userDictionary = userSnapshot.value as? [String: AnyObject]
                self.name.text = userDictionary!["name"] as? String
                self.city.text = userDictionary!["city"] as? String
                
                // Load profile picture
                if let imageURL = userDictionary!["profilepic"] as? String{
                    let url = URL(string: imageURL)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        DispatchQueue.main.async() {
                            self.profilePictureImage?.image = UIImage(data:data!)
                        }
                    }).resume()
                }
            }
        })
        // Load upcoming events
        self.ref?.child("Activities_Events").queryOrdered(byChild: "date").observe(DataEventType.value, with: {
            (snapshot) in
            self.eventIDs.removeAll()
            self.homeTableContents[1].removeAll()
            self.activity_day.removeAll()
            var firstChildMatch = 0
                
            for sessionSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                guard let isUserInEvent = sessionSnapshot.childSnapshot(forPath: "Participants/\(self.currentuserID)").value as? [String:AnyObject] else {continue}
                // Filtering out event/activity that has passed and load the future events into the table
                if isUserInEvent.count > 0 {
                    firstChildMatch += 1
                    if firstChildMatch == 1 {
                        guard let oldestActivityDictionary = sessionSnapshot.value as? [String:AnyObject] else {continue}
                        guard let tempOldestDate = oldestActivityDictionary["date"] as? String else {continue}
                        self.createActivityArrays(oldestDate: tempOldestDate)
                    }
                    
                    guard let sessionDictionary = sessionSnapshot.value as? [String: AnyObject] else {continue}
                    guard let isPersonal = sessionDictionary["isPersonal"] as? Int else {continue}
                    guard let tempEventDate = sessionDictionary["date"] as? String else {continue}
                    guard let tempEventDuration = sessionDictionary["duration_minute"] as? String else {continue}
                    let today = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let todayString = formatter.string(from: today)
                        // Check if event has passed, if so, add event duration into activity tracker
                        if isPersonal == 0 && todayString <= tempEventDate {
                            self.homeTableContents[1].append((sessionDictionary["event_name"] as? String)!)
                            self.eventIDs.append(sessionSnapshot.key)
                        }
                        else if todayString > tempEventDate{
                            self.appendActivity(key: tempEventDate, value: Int(tempEventDuration)!)
                        }
                }
            }
            print (self.activity_day)
            DispatchQueue.main.async() {
                self.myTableView.reloadData()
            }
        })
    }
    //============Profile picture picker==================
    //  code referenced from the following youtube video
    //  https://www.youtube.com/watch?v=XmyiRzeoSJE
    
    // "Upload Image" button action when clicked
    @IBAction func uploadProfilePic(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    // Let user pick image from their photo album
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            profilePictureImage.image = selectedImage
            saveImageToDB()
        }
        dismiss(animated: true, completion: nil)
    }
    
    // Dismiss if image picker controller is canceled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Upload the profile to database
    func saveImageToDB(){
        let imageName = NSUUID().uuidString
        let storedImage = storageRef.child("profile_images").child(imageName)
        
        if let uploadData = self.profilePictureImage.image!.pngData(){
            storedImage.putData(uploadData, metadata: nil, completion:{ (metadata, error) in
                if error != nil{
                    print(error!)
                }
                storedImage.downloadURL(completion: {(url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    if let urlText = url?.absoluteString{
                        self.ref?.child("Users").child(self.currentuserID).updateChildValues(["profilepic" : urlText], withCompletionBlock: {(error, ref) in
                            if error != nil{
                                print(error!)
                                return
                            }
                        })
                    }
                })
            })
        }
    }
    //============Profile picture picker end==================
    
    // Return table count
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeTableSections.count
    }
    
    // Return table header name
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return homeTableSections[section]
    }
    
    // Return the number of rows in for a section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeTableContents[section].count
    }
    
    // Return the name for the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for:  indexPath)
        cell.textLabel?.text = homeTableContents[indexPath.section][indexPath.row]
        return cell
    }
    
    // Go either to the event view controller or the histogram view controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: homeTableSections[indexPath.section], sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // This function provides the header for the navigation bar in the histogram view controller and
    // the events view controller based on the name of the cell pressed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showPendingRequest"){
            print("Request button is clicked")
        }
        else if(self.myTableView.indexPathForSelectedRow != nil){
            var indexPath = self.myTableView.indexPathForSelectedRow!
            
            if(indexPath.section == 0){
                let destination = segue.destination as! HistogramViewController
                destination.navigationItem.title = homeTableContents[indexPath.section][indexPath.row]
                destination.histogramData = activity_day
            }
            else{
                let destination = segue.destination as! UserEventsViewController
                destination.navigationItem.title = homeTableContents[indexPath.section][indexPath.row]
                destination.eventId = eventIDs[indexPath.row]
            }
        }
        else{
            print("self.myTableView.indexPathForSelectedRow is nil")
        }
    }
    
    
    // Add time to a certain day. Key is the day, value is the activity minutes
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
    
    // Set up for the histogram page, create an array with place holders for each day
    // Array size will be the date difference between today's date and the oldest activity
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
        if activity_day_count >= 0{
            for i in 0...activity_day_count{
                let tempDate:Date = Calendar.current.date(byAdding: .day, value: i, to: oldest!)!
                let tempDateString = dateFormatter.string(from: tempDate)
                activity_day[tempDateString] = 0
            }
        }
    }
}
