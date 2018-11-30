//
//  RequestTableViewCell.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-11-29.
//  Copyright © 2018 Daycar. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {

    let acceptButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.green
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Accept", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    let declineButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Decline", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(acceptButton)
        contentView.addSubview(declineButton)
        acceptButton.rightAnchor.constraint(equalTo: declineButton.leftAnchor, constant: -15).isActive = true
        acceptButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        acceptButton.widthAnchor.constraint(equalTo: self.acceptButton.widthAnchor).isActive = true
        acceptButton.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        
        declineButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        declineButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        declineButton.widthAnchor.constraint(equalTo: self.acceptButton.widthAnchor).isActive = true
        declineButton.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
