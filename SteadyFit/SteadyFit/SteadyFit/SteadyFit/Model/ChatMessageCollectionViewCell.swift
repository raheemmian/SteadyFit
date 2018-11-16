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
        text.text = "Sample"
        text.font = UIFont.systemFont(ofSize: 18)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = UIColor.clear
        text.textColor = UIColor.white
        return text
    }()
    
    var bubbleWidth: NSLayoutConstraint?
    static let blueForChatBox = UIColor(red: 0, green: 135, blue: 250, alpha: 0)
//    static let grayForChatBox =
    let bubbleView: UIView = {
        let bubble = UIView()
        bubble.backgroundColor = blueForChatBox
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.layer.cornerRadius = 12
        bubble.layer.masksToBounds = true
        return bubble
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        
        //  Set contrainst
        // youtube at 12:24
        // set reference of bubble anchor
        
        
        
        
        
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidth = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidth?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
