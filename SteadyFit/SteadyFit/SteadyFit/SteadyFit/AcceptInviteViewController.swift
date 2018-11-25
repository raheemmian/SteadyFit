//
//  AcceptInviteViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-11-23.
//  Copyright © 2018 Daycar. All rights reserved.
//

import UIKit

class AcceptInviteViewController: UIViewController {

    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.setTitleColor(.black, for: .normal)
        acceptButton.backgroundColor = UIColor.green
        declineButton.setTitle("Decline", for: .normal)
        declineButton.setTitleColor(.black, for: .normal)
        declineButton.backgroundColor = UIColor.red
    }
    @IBAction func acceptButtonAction(_ sender: Any) {
    }
    @IBAction func declineButtonAction(_ sender: Any) {
    }
    
}


