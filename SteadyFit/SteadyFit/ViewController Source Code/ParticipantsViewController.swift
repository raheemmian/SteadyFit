//
//  ParticipantsViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-11-18.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//
//  Edited by: Raheem Mian
//
//  This view controller is strictly for checking the database for the participants of a specific event
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ParticipantsViewController: EmergencyButtonViewController, UITableViewDelegate, UITableViewDataSource {
    var ref:DatabaseReference? = Database.database().reference()
    var refHandle:DatabaseHandle?
    var eventId:String = ""
    var participants = [String]()
    @IBOutlet weak var participantTableView: UITableView!
    
    override func viewDidLoad() {
        //checks the participants list for the clicked on event
        //and loads it to the table view
        super.viewDidLoad()
        self.navigationItem.title = "Participants"
        participantTableView.delegate = self
        participantTableView.dataSource = self
        participantTableView.tableFooterView = UIView()
        refHandle = ref?.child("Activities_Events").child(eventId).child("Participants").observe(.value, with: { (snapshot) in
            if(snapshot.childrenCount > 0){
                self.participants.removeAll()
                for participant in snapshot.children.allObjects as! [DataSnapshot] {
                    let nameObject = (participant.value as? [String: AnyObject])!
                    let name = nameObject["name"]
                    self.participants.append(name as! String)
                }
                self.participantTableView.reloadData()
            }
            
        })
    }
    //table functions loading the participants of the event
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell  = tableView.dequeueReusableCell(withIdentifier: "participantCell", for:  indexPath)
        tableCell.textLabel?.text = participants[indexPath.row]
        return tableCell
    }

}
