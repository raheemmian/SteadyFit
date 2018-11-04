//
//  GroupViewController.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-10-28.
//  Copyright © 2018 Raheem Mian. All rights reserved.
//
//  Team Daycar
//  Edited by: Dickson Chum
//  List of Changes: added labels, table and arrays for table, created segues for table view
//
//  GroupViewController.swift is linked to Group Profile of the UI, which shows group information.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var groupDesc: UILabel!
    @IBOutlet weak var groupDescInfo: UILabel!
    @IBOutlet weak var activityLevel: UILabel!
    @IBOutlet weak var activityLevelInfo: UILabel!
    @IBOutlet weak var groupStatus: UILabel!
    @IBOutlet weak var groupStatusInfo: UILabel!
    @IBOutlet weak var eventTableView: UITableView!
    
    var groupName: String!
    var groupTableSections = ["Members", "Events"]
    var groupTableContents = [["More"], ["A Event on Jan 1, 2018", "B Event on Feb 1, 2018", "C Event on Mar 1, 2018"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.delegate = self
        eventTableView.dataSource = self
        groupDesc.text = "Group Description:"
        groupDescInfo.text = "(Group Description)"
        activityLevel.text = "Activity Level:"
        activityLevelInfo.text = "(Activity Level)"
        groupStatus.text = "Group Status:"
        groupStatusInfo.text = "(Group Status)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupTableSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupTableSections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupTableContents[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = eventTableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
        cell.textLabel?.text = groupTableContents[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: groupTableSections[indexPath.section], sender: self)
        eventTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = self.eventTableView.indexPathForSelectedRow!
        if(indexPath.section == 0){
            let post = segue.destination as! GroupMemberListTableViewController
            post.navigationItem.title = groupTableContents[indexPath.section][indexPath.row]
        }
        else{
            let post = segue.destination as! EventViewController
            post.navigationItem.title = groupTableContents[indexPath.section][indexPath.row]
        }
    }
}
