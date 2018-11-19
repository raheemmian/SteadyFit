//
//  EmergencyButtonViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-11-19.
//  Copyright © 2018 Daycar. All rights reserved.
//

import UIKit
import MessageUI
import MapKit
import CoreLocation

class EmergencyButtonViewController: UIViewController, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    @IBOutlet weak var emergencyButton: UIButton!
    
    @IBAction func emergencyButtonPressed(){
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        sendText()
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        /*The message controller is dismissed once the message is either sent or the cancel button is pressed. It segues back
         to the screen where the emergency button was pressed*/
        controller.dismiss(animated: true, completion: nil)
    }
    
    func sendText() {
        /*This function is for bringing up the messsage controller once the emergency button is pressed
         and automatically putting a custom message and current location*/
        let composeVC = MFMessageComposeViewController()
        if(CLLocationManager.locationServicesEnabled()){
            /*get the coordinates for the person and put into a google link */
            locationManager.startUpdatingLocation()
            let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
            composeVC.body = "I need help! This is my current location: " + "http://maps.google.com/maps?q=\(locValue.latitude),\(locValue.longitude)&ll=\(locValue.latitude),\(locValue.longitude)&z=17"
        }
        else{
            /*if location services is not enabled*/
            composeVC.body = "I need help!"
        }
        composeVC.messageComposeDelegate = self
        composeVC.recipients = ["7788823644"]
        if MFMessageComposeViewController.canSendText() {
            /*if the message view controller is available then send the text*/
            self.present(composeVC, animated: true, completion: nil)
        } else {
            
            print("Can't send messages.")
        }
    }
}
