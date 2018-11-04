//
//  FriendsViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-10-23.
//  Copyright © 2018 Daycar. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let friendList = ["Friend A", "Friend B", "Friend C", "Friend D"]
    @IBOutlet weak var friendTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendTableView.tableFooterView = UIView(frame: .zero)
        friendTableView.delegate = self
        friendTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let tableCell = friendTableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        tableCell.textLabel?.text = friendList[indexPath.row]
        return tableCell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "friends", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = self.friendTableView.indexPathForSelectedRow!
            let post = segue.destination as! FriendProfileViewController
            post.navigationItem.title = friendList[indexPath.row]
    }
    
}
