//
//  RequestTableViewCell.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-12-01.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Dickson Chum
//  List of Changes: added Accept and Decline button, added buttonAction to update database node depends on which button is clicked.
//
//  RequestTableViewCell.swift is the structure for tableViewCell in PendingRequestViewConstroller.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RequestTableViewCell: UITableViewCell {
    // Declare all variables needed for database action
    var ref:DatabaseReference? = Database.database().reference()
    var section = -1
    var row = -1
    var friendID = ""
    var friendGroupID = ""
    var groupID = ""
    var chatID = ""
    var friendName = ""
    var friendChat = ""
    var groupName = ""
    var groupType = ""
    var groupChat = ""
    var post = [String: Any]()

    // Declare accept button
    let acceptButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Accept", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 12
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    // Declare decline button
    let declineButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Decline", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 12
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    // Set up elements when cell is called
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(acceptButton)
        addSubview(declineButton)
        acceptButton.tag = 0
        declineButton.tag = 1
        
        // Call buttonAction when button is clicked
        acceptButton.addTarget(self, action: #selector(buttonAction), for: UIControl.Event.touchUpInside)
        declineButton.addTarget(self, action: #selector(buttonAction), for: UIControl.Event.touchUpInside)
        
        // Set constraints
        acceptButton.rightAnchor.constraint(equalTo: declineButton.leftAnchor, constant: -15).isActive = true
        acceptButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        acceptButton.widthAnchor.constraint(equalTo: acceptButton.widthAnchor).isActive = true
        acceptButton.heightAnchor.constraint(equalToConstant: self.frame.height - 10).isActive = true
        
        declineButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        declineButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        declineButton.widthAnchor.constraint(equalTo: declineButton.widthAnchor).isActive = true
        declineButton.heightAnchor.constraint(equalToConstant: self.frame.height - 10).isActive = true
    }
    
    // Catch init error, needed by Xcode
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Button action when accept or decline button is clicked
    // Add or delete node in database based on the button is clicked
    @objc func buttonAction(sender: UIButton){
        // Accept button action
        if(sender.tag == 0){
            ref?.updateChildValues(post)
        }
        // Decline button action
        else if(sender.tag == 1){
            if(section == 0){
                let removeFriendRef = self.ref?.child("Groups").child(friendGroupID)
                removeFriendRef!.removeValue { error, _ in
                    print(error as Any)
                }
                let removeChatRef = self.ref?.child("Chats").child(chatID)
                removeChatRef!.removeValue { error, _ in
                    print(error as Any)
                }
            }
            else{
                let removeGroupRef = self.ref?.child("Groups").child(groupID)
                removeGroupRef!.removeValue { error, _ in
                    print(error as Any)
                }
                let removeChatRef = self.ref?.child("Chats").child(chatID)
                removeChatRef!.removeValue { error, _ in
                    print(error as Any)
                }
            }
        }
    }
}
