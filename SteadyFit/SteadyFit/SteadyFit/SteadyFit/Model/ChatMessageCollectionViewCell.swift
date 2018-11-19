//
//  ChatMessageCollectionViewCell.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-11-04.
//
//  Team Daycar
//  Edited by: Dickson Chum
//
//  ChatMessageCollectionViewCell.swift is the structure for chat message view.
//

import UIKit

class ChatMessageCollectionViewCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let text = UITextView()
        text.text = "Sample Message"
        text.font = UIFont.systemFont(ofSize: 16)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = UIColor.clear
        text.textColor = UIColor.white
        text.isEditable = false
        return text
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    //    static let blueForChatBox = UIColor(red: 0/255, green: 135/255, blue: 250/255, alpha: 0)
    
    let bubbleView: UIView = {
        let bubble = UIView()
        bubble.backgroundColor = UIColor.blue
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.layer.cornerRadius = 12
        bubble.layer.masksToBounds = true
        return bubble
    }()
    
    let senderNameView: UILabel = {
        let senderName = UILabel()
        senderName.text = "John Doe"
        senderName.isHidden = false
        senderName.font = UIFont.systemFont(ofSize: 10)
        senderName.translatesAutoresizingMaskIntoConstraints = false
        senderName.backgroundColor = UIColor.clear
        senderName.textColor = UIColor.lightGray
        return senderName
    }()
    
    let profilePicView: UIImageView = {
        let profilePic = UIImageView()
        profilePic.image = UIImage(named: "ProfilePic")
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        profilePic.layer.cornerRadius = 15
        profilePic.layer.masksToBounds = true
        profilePic.contentMode = .scaleAspectFill
        return profilePic
    }()
    var testContrainst: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(senderNameView)
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profilePicView)
        
        // Set contrainst
        senderNameView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        senderNameView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor, constant: -5).isActive = true
        senderNameView.bottomAnchor.constraint(equalTo: bubbleView.topAnchor, constant: -2).isActive = true
        senderNameView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profilePicView.rightAnchor, constant: 8)
        bubbleLeftAnchor?.isActive = false
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleRightAnchor?.isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        profilePicView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profilePicView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
        profilePicView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        profilePicView.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
