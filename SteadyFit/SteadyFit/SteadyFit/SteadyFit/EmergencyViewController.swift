//
//  EmergencyViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-10-29.
//  Copyright © 2018 Daycar. All rights reserved.

//not using this in the app//

import UIKit
import MessageUI

class EmergencyViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
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
            //sendTextMesssage()
        }
    }
    
    
    func sendTextMesssage() {
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.recipients = ["7788823644"]
            composeVC.body = "I love Swift!"
            
            // Present the view controller modally.
            if MFMessageComposeViewController.canSendText() {
                self.present(composeVC, animated: true, completion: nil)
            } else {
                print("Can't send messages.")
            }
    }
}
