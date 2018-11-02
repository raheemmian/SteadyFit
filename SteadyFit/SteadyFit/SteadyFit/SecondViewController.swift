//
//  SecondViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-10-23.
//  Copyright © 2018 Raheem Mian. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var sampleMyGroups = ["Group A", "Group B", "Group C"]
    var sampleSuggestedGroups = ["Group X", "Group Y", "Group Z"]
    var p: Int!
    
    @IBOutlet weak var groupTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        p = 0
    }
    
    func tableView(_ groupTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        
        switch (p) {
        case 0:
            returnValue = sampleMyGroups.count
            break
        case 1:
            returnValue = sampleSuggestedGroups.count
            break
        default:
            break
        }
        return returnValue
    }
    
    
    func tableView(_ groupTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupTableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        
        switch (p) {
        case 0:
            cell.textLabel!.text = sampleMyGroups[indexPath.row]
            break
        case 1:
            cell.textLabel!.text = sampleSuggestedGroups[indexPath.row]
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ groupTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        groupTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showGroupDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (p) {
        case 0:
            if let destination = segue.destination as? GroupViewController{
                destination.groupName = sampleMyGroups[(groupTableView.indexPathForSelectedRow?.row)!]
            }
            break
        case 1:
            if let destination = segue.destination as? GroupViewController{
                destination.groupName = sampleSuggestedGroups[(groupTableView.indexPathForSelectedRow?.row)!]
            }
            break
        default:
            break
        }
        
    }
    
    
    @IBAction func groupSegmentedControl(_ sender: UISegmentedControl) {
        p = sender.selectedSegmentIndex
        groupTableView.reloadData()
    }
}

