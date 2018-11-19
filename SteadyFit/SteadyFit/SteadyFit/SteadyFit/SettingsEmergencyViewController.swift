//
//  SettingsEmergencyViewController.swift
//  SteadyFit
//
//  Created by Yimin Long on 2018-11-17.
//  Copyright © 2018 Daycar. All rights reserved.
//  Edited by: Yimin Long
//  List of Changes: User can change their emergency contact number. Editing emergency message not done.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SettingsEmergencyViewController: UIViewController {
    
    var ref:DatabaseReference?
    var refHandle:DatabaseHandle?
    let currentuserID = (Auth.auth().currentUser?.uid)!
    var currentUserEmergencyContact: String?
    var emergencyMessage: String?
    
    @IBAction func emergencyContectNumberTextField(_ sender: UITextField) {
    }
    @IBOutlet weak var emergencyContectNumberTextBox: UITextField!
    
    
    @IBAction func EmergencyMessageTextField(_ sender: UITextField) {
    }
    
    //    @IBOutlet weak var emergencyMessageTextBox: UITextField!
    @IBOutlet weak var emergencyMessageTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        self.ref!.child("Users").child(currentuserID).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let userDictionary = snapshot.value as? [String: AnyObject]
            print (snapshot)
            
            if userDictionary != nil{
                self.currentUserEmergencyContact = userDictionary!["emergencycontact"] as? String
                self.emergencyMessage = userDictionary!["emergencymessage"] as? String
            }
            DispatchQueue.main.async{
                self.emergencyContectNumberTextBox.text = self.currentUserEmergencyContact
                self.emergencyMessageTextBox.text = self.emergencyMessage
            }
            
        })
        
        // Do any additional setup after loading the view.
    }
    
    // Update Emergency contact and message
    @IBAction func emergencySaveButton(_ sender: UIButton) {
        if emergencyContectNumberTextBox.text != nil && emergencyMessageTextBox.text != nil {
            let newUserInfo = ["/Users/\(currentuserID)/emergencycontact": emergencyContectNumberTextBox.text,
                               "/Users/\(currentuserID)/emergencymessage": emergencyMessageTextBox.text] as [String:Any]
            ref?.updateChildValues(newUserInfo)
        }
    }
}
