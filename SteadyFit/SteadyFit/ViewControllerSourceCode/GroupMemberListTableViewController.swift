//
//  GroupMemberListTableViewController.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-11-03.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Dickson Chum
//  List of Changes: added table and array for table, created segues for table view
//
//  GroupMemberListTableViewController.swift is linked to Group Member List of the UI, which shows all the members of the corresponding group.
//

import UIKit

class GroupMemberListTableViewController: UITableViewController {
    var memberList = [String]()
    var memberIdList = [String]()
    @IBOutlet weak var memberListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memberListTableView.delegate = self
        memberListTableView.dataSource = self
    }
    
    // Return number of section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // Return rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberList.count
    }
    // Setup cell in each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberListTableView.dequeueReusableCell(withIdentifier: "memberListCell", for: indexPath)
        cell.textLabel!.text = memberList[indexPath.row]
        return cell
    }
    // Perform segue when row is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showProfile", sender: self)
        memberListTableView.deselectRow(at: indexPath, animated: true)
    }
    // Perform segue when different section is clicked
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = self.memberListTableView.indexPathForSelectedRow!
        let destination = segue.destination as! UserProfileViewController
        destination.friendUserId = memberIdList[indexPath.row]
    }
}
