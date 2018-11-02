//
//  EmergencyViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-10-29.
//  Copyright © 2018 Raheem Mian. All rights reserved.
//

import UIKit

class EmergencyViewController: UIViewController {

    
    @IBOutlet weak var beforeMessage: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    var time = 5;
    var timer = Timer();
    override func viewDidLoad() {
        super.viewDidLoad()
        beforeMessage.text = "EMERGENCY CONTACT WILL BE CONTACTED IN ALLOTED TIME:"
        message.text = " PRESS HOME TO CANCEL"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(action), userInfo: nil, repeats: true)
    }
    @objc func action(){
        time -= 1;
        countDownLabel.text = String(time);
        if(time == 0){
            message.text = "A text message with your location has been sent to your emergency contact."
            beforeMessage.isHidden = true
            timer.invalidate()
        }
    }
}
