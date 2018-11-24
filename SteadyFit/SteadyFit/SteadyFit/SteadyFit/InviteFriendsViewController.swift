//
//  InviteFriendsViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-11-23.
//  Copyright © 2018 Daycar. All rights reserved.
//

import UIKit

class InviteFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var inviteUserTableView: UITableView!
    var friendsInviteList = ["Friend A", "Friend B"]
    override func viewDidLoad() {
        super.viewDidLoad()
        inviteUserTableView.delegate = self
        inviteUserTableView.dataSource = self
        inviteUserTableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsInviteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = inviteUserTableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        let image = UIImage(named: "plus")
        let button = UIButton()
        button.frame = CGRect(x: view.bounds.maxX - 44, y: 0, width: 44, height: 44)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(inviteButtonPressed), for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        cell.textLabel?.text = friendsInviteList[indexPath.row]
        cell.contentView.addSubview(button)
        return cell
    }
    
    @objc func inviteButtonPressed(sender: UIButton!){
        //sender.isHidden = true
        let image = UIImage(named: "checkmark")
        sender.setImage(image, for: .normal)
        /*need to add the functionality everytime the button is pressed
         then an invite request is sent to a user
        */
    }
}
