//
//  InviteFriendsViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-11-23.
//  Copyright © 2018 Daycar. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class InviteFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var inviteUserTableView: UITableView!
    var ref:DatabaseReference? = Database.database().reference()
    var friendsInviteList: [String] = []
    var friendsIdList: [String] = []
    var groupId = ""
    let currentuserID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inviteUserTableView.delegate = self
        inviteUserTableView.dataSource = self
        inviteUserTableView.tableFooterView = UIView()
        
        if currentuserID != nil {
            //friendsInviteList.removeAll()
            //friendsIdList.removeAll()
            ref?.child("Users").child(currentuserID!).child("Friends").observeSingleEvent(of: .value, with: {(snapshot) in
                for rest in snapshot.children.allObjects as! [DataSnapshot]{
                    guard let dictionary = rest.value as? [String: AnyObject] else {continue}
                    let friendName = dictionary["name"] as?String
                    let friendId = rest.key
                    if (friendName != nil && friendId != ""){
                        self.friendsInviteList.append(friendName!)
                        self.friendsIdList.append(friendId)
                    }
                }
            })
        }
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
        button.tag = indexPath.row
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
        /* alexa look here, uncomment this when requests are done
        let invitedUserId = friendsIdList[sender.tag]
        let invitedUserName = friendsInviteList[sender.tag]
        if (groupId != "" && invitedUserId != "" && invitedUserName != ""){
            let post = [ "/Groups/\(groupId)/users/\(invitedUserId)":
                ["name":invitedUserName, "joined":0]] as [String : Any]
            ref?.updateChildValues(post)
        }
        */
    }
}
