//
//  ParticipantsViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-11-18.
//  Copyright © 2018 Daycar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
protocol MyProtocol{
    func checkGoing(going: String)
}


class ParticipantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var ref:DatabaseReference? = Database.database().reference()
    var refHandle:DatabaseHandle?
    var eventId:String = ""
    var participants = [String]()
    var myProtocol: MyProtocol?
    @IBOutlet weak var participantTableView: UITableView!
    
    
    override func viewDidLoad() {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell  = tableView.dequeueReusableCell(withIdentifier: "participantCell", for:  indexPath)
        tableCell.textLabel?.text = participants[indexPath.row]
        return tableCell
    }

}
