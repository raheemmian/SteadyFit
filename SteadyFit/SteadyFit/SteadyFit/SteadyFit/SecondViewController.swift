//
//  SecondViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-10-23.
//  Copyright © 2018 Raheem Mian. All rights reserved.
//
//  Team Daycar
//
//  Edited by: Dickson Chum, Alexa Chen
//  List of Changes: added segmented control, table and arrays for table, created segues for table view, added database automatic population for user "My Group"
//
//  SecondViewController.swift is connected to Groups section of the UI, which shows user joined groups and recommmented groups by toggling on segmented control
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var myGroups = [String]()
    var suggestedGroups = ["Group X", "Group Y", "Group Z"]
    var p: Int!
    
    var queryMyGroups = [userGroup]()
    var ref:DatabaseReference?
    var refHandle:DatabaseHandle?

    @IBOutlet weak var groupTableView: UITableView!
    @IBAction func groupSegmentedControl(_ sender: UISegmentedControl) {
        p = sender.selectedSegmentIndex
        groupTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  Database initialization
        ref = Database.database().reference()
        let currentuserID = Auth.auth().currentUser?.uid
        refHandle = ref?.child("Users").child(currentuserID!).child("Groups").observe(DataEventType.value, with: {
            (snapshot) in
            self.myGroups.removeAll()
            self.queryMyGroups.removeAll()
            for rest in snapshot.children.allObjects as! [DataSnapshot]{
                guard let dictionary = rest.value as? [String: AnyObject] else {continue}
                let myGroup = userGroup()
                myGroup.name = dictionary["name"] as?String
                myGroup.chatid = dictionary["name"] as?String
                myGroup.GroupType = dictionary["GroupType"] as?String
                self.queryMyGroups.append(myGroup)
                if myGroup.name != nil {
                    let sampleGroup: String = myGroup.name!
                    self.myGroups.append(sampleGroup)
                }
                DispatchQueue.main.async{
                    self.groupTableView.reloadData()
                }
            }
        })
        //  End of Database initialization
        
        p = 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        switch (p) {
        case 0:
            returnValue = myGroups.count
            break
        case 1:
            returnValue = suggestedGroups.count
            break
        default:
            break
        }
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupTableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        switch (p) {
        case 0:
            cell.textLabel?.text = myGroups[indexPath.row]
            break
        case 1:
            cell.textLabel?.text = suggestedGroups[indexPath.row]
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showGroupDetail", sender: self)
        groupTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = self.groupTableView.indexPathForSelectedRow!
        switch (p) {
        case 0:
            let destination = segue.destination as! GroupViewController
            destination.navigationItem.title = myGroups[indexPath.row]
            break
        case 1:
            let destination = segue.destination as! GroupViewController
            destination.navigationItem.title = suggestedGroups[indexPath.row]
            break
        default:
            break
        }
    }
}



