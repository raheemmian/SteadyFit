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

class UserEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var eventsTableView: UITableView!
    var location:String = "Vancouver"
    var date:String = "September 30 2018"
    var startTime: String = "12:00"
    var endTime: String = "3:00"
    var duration:String = " - "
    
    
    
    var eventDescription = ["Location: " , "Date: ", "Duration: "]
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        descriptionTextView.isEditable = false
        self.duration = startTime + " - " + endTime
        self.descriptionTextView.text = "This is the description"
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*Location, Date, Duration
        */
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*return the name for the cell*/
        let tableCell  = tableView.dequeueReusableCell(withIdentifier: "EventDescriptionTableCell", for:  indexPath)
        if(indexPath.row == 0 ){
            tableCell.textLabel?.text = eventDescription[indexPath.row] + location
        }
        else if(indexPath.row == 1){
            tableCell.textLabel?.text = eventDescription[indexPath.row] + date
        }
        else{
            tableCell.textLabel?.text = eventDescription[indexPath.row] + duration
        }
        return tableCell
    }

}
