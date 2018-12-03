//
//  SettingsEmergencyViewController.swift
//  SteadyFit
//
//  Created by Yimin Long on 2018-11-17.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//
//  Edited by: Yimin Long
//  List of Changes: User can change their emergency contact number. Editing emergency message not done.
//
//  SettingsEmergencyViewController.swift is corresponding to Emergency Contact section in Settings.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SettingsEmergencyViewController: EmergencyButtonViewController {
    // Variables and objects declaration
    var ref:DatabaseReference?
    var refHandle:DatabaseHandle?
    let currentuserID = (Auth.auth().currentUser?.uid)!
    var currentUserEmergencyContact: String?
    var EmergencyMessage: String?
    
    @IBAction func emergencyContectNumberTextField(_ sender: UITextField) {
    }
    @IBOutlet weak var emergencyContectNumberTextBox: UITextField!
    
    
    @IBAction func EmergencyMessageTextField(_ sender: UITextField) {
    }
    @IBOutlet weak var emergencyMessageTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Loading current data from database 
        ref = Database.database().reference()
        
        self.ref!.child("Users").child(currentuserID).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let userDictionary = snapshot.value as? [String: AnyObject]
            print (snapshot)
            
            if userDictionary != nil{
                self.currentUserEmergencyContact = userDictionary!["emergencycontact"] as? String
                self.EmergencyMessage = userDictionary!["emergencymessage"] as? String
            }
            DispatchQueue.main.async{
                self.emergencyContectNumberTextBox.text = self.currentUserEmergencyContact
                self.emergencyMessageTextBox.text = self.EmergencyMessage
            }
        })
    }
    
    // Update Emergency contact and message to database
    @IBAction func emergencySaveButton(_ sender: UIButton) {
        if emergencyContectNumberTextBox.text != nil && emergencyMessageTextBox.text != nil {
            let newUserInfo = ["/Users/\(currentuserID)/emergencycontact": emergencyContectNumberTextBox.text!,
                               "/Users/\(currentuserID)/emergencymessage": emergencyMessageTextBox.text!] as [String:Any]
            ref?.updateChildValues(newUserInfo)
            navigationController?.popViewController(animated: true)
        }
    }
}
