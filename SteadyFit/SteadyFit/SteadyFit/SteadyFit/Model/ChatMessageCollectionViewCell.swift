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
        text.font = UIFont.systemFont(ofSize: 18)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = UIColor.clear
        text.textColor = UIColor.white
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
    
    let senderBubbleView: UIView = {
        let senderBubble = UIView()
        senderBubble.backgroundColor = UIColor.red
        senderBubble.translatesAutoresizingMaskIntoConstraints = false
        //        senderBubble.layer.cornerRadius = 12
        senderBubble.layer.masksToBounds = true
        return senderBubble
    }()
    
    let senderNameView: UITextView = {
        let senderName = UITextView()
        senderName.text = "John Doe"
        senderName.font = UIFont.systemFont(ofSize: 10)
        senderName.translatesAutoresizingMaskIntoConstraints = false
        senderName.backgroundColor = UIColor.red
        senderName.textColor = UIColor.black
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
        addSubview(senderBubbleView)
        addSubview(senderNameView)
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profilePicView)
        
        //  Set contrainst
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profilePicView.rightAnchor, constant: 8)
        bubbleLeftAnchor?.isActive = false
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleRightAnchor?.isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //        testContrainst = senderBubbleView.heightAnchor.constraint(equalTo: senderNameView.heightAnchor)
        
        
        //        testContrainst?.isActive = true
        //        print(testContrainst?.constant as Any)
        senderBubbleView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        senderBubbleView.bottomAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        senderBubbleView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        senderBubbleView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        
        senderNameView.leftAnchor.constraint(equalTo: senderBubbleView.leftAnchor).isActive = true
        senderNameView.rightAnchor.constraint(equalTo: senderBubbleView.rightAnchor).isActive = true
        senderNameView.topAnchor.constraint(equalTo: senderBubbleView.topAnchor).isActive = true
        senderNameView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        //        senderNameView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        // fix sendername view to show name in chat
        
        
        
        profilePicView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profilePicView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profilePicView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        profilePicView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
