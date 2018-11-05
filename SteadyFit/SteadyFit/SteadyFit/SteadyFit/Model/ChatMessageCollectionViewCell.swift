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
        text.font = UIFont.systemFont(ofSize: 15)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = UIColor.clear
        text.textColor = UIColor.white
        return text
    }()
    
    let bubbleView: UIView = {
        let bubble = UIView()
        bubble.backgroundColor = UIColor.blue
        bubble.translatesAutoresizingMaskIntoConstraints = false
        return bubble
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        
        //  Set contrainst
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
