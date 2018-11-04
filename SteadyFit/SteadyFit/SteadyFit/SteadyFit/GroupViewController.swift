//
//  GroupViewController.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-10-28.
//  Copyright © 2018 Raheem Mian. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
   
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var groupDesc: UILabel!
    @IBOutlet weak var groupDescInfo: UILabel!
    @IBOutlet weak var activityLevel: UILabel!
    @IBOutlet weak var activityLevelInfo: UILabel!
    @IBOutlet weak var groupStatus: UILabel!
    @IBOutlet weak var groupStatusInfo: UILabel!
    
    @IBOutlet weak var eventTableView: UITableView!
    
    var groupName: String!
    
    var tableTitle = ["Members", "Events"]
    var tableContent = [["More"], ["A Event on Jan 1, 2018", "B Event on Feb 1, 2018", "C Event on Mar 1, 2018"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.delegate = self
        eventTableView.dataSource = self
        // Do any additional setup after loading the view.
        groupLabel.text = groupName
        groupDesc.text = "Group Description:"
        groupDescInfo.text = "(Group Description)"
        activityLevel.text = "Activity Level:"
        activityLevelInfo.text = "(activity level)"
        groupStatus.text = "Group Status:"
        groupStatusInfo.text = "(Group Status)"
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableTitle[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = eventTableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
        cell.textLabel?.text = tableContent[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: tableTitle[indexPath.section], sender: self)
        eventTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = self.eventTableView.indexPathForSelectedRow!
        if(indexPath.section == 0){
            let post = segue.destination as! GroupMemberListTableViewController
            post.navigationItem.title = tableContent[indexPath.section][indexPath.row]
        }
        else{
            let post = segue.destination as! EventViewController
            post.navigationItem.title = tableContent[indexPath.section][indexPath.row]
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        var indexPath = self.eventTableView.
//    }
    
}
