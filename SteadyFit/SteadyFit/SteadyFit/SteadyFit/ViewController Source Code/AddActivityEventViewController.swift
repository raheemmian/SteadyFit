//
//  AddActivityEventViewController.swift
//  SteadyFit
//
//  Created by Akshay Kumar on 2018-11-09.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Akshay Kumar
//
//  AddActivityEventViewController.swift is the view controller for adding a new event.
//  It allows you to select a name, description, duration and date and saves it to the database.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class AddActivityEventViewController: EmergencyButtonViewController, UITextFieldDelegate {

    // Variables and objects declaration
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var DTAddActivitytextfield: UITextField!
    @IBOutlet weak var DurationActivitytextfield: UITextField!
    @IBOutlet weak var NameActivityTextField: UITextField!
    @IBOutlet weak var DescriptionActivitytextfield: UITextField!
    var ref:DatabaseReference? = Database.database().reference()
    var refHandle:DatabaseHandle?
    var myUserID = (Auth.auth().currentUser?.uid)!
    var myUserName: String = ""
    let datePicker = UIDatePicker()
    let durationPicker = UIDatePicker()
    
    //Displays an error if any field is left empty, otherwise sends all the entered data to the database
    @IBAction func saveButton(_ sender: Any) {
        if((DTAddActivitytextfield.text?.isEmpty)! || (DurationActivitytextfield.text?.isEmpty)! || (NameActivityTextField.text?.isEmpty)! || (DescriptionActivitytextfield.text?.isEmpty)!) {self.errorLabel.isHidden = false}
        else{
            let key:String = (ref!.child("Activities_Events").childByAutoId().key)!
            let post = ["/Activities_Events/\(key)/Participants": [myUserID: ["name": myUserName]],
                        "/Activities_Events/\(key)/date": DTAddActivitytextfield.text ?? "nothing",
                        "/Activities_Events/\(key)/event_name": NameActivityTextField.text ?? "nothing",
                        "/Activities_Events/\(key)/description": DescriptionActivitytextfield.text ?? "nothing",
                        "/Activities_Events/\(key)/duration_minute": DurationActivitytextfield.text ?? "nothing",
                        "/Activities_Events/\(key)/isPersonal": 1,
                ] as [String : Any]
            ref?.updateChildValues(post)
            
            // Segue back to home
            performSegue(withIdentifier: "goHomeAfterAddActivity", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NameActivityTextField.delegate = self
        DescriptionActivitytextfield.delegate = self
        self.errorLabel.isHidden = true
        
        // Data and time field
        datePicker.datePickerMode = .dateAndTime
        DTAddActivitytextfield.inputView=datePicker
        datePicker.addTarget(self, action: #selector(AddActivityEventViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddActivityEventViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        // Durationfield
        durationPicker.datePickerMode = .countDownTimer
        DurationActivitytextfield.inputView = durationPicker
        durationPicker.addTarget(self, action: #selector(AddActivityEventViewController.dateChanged1(datePicker:)), for: .valueChanged)
        
        _ = UITapGestureRecognizer(target: self, action: #selector(AddActivityEventViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        ref?.child("Users").child(myUserID).child("name").observeSingleEvent(of: .value, with: {(snapshot) in
            self.myUserName = (snapshot.value as? String)!
        })
    }

    // Set text field as first responder
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Action of tap gesture
    @objc func viewTapped(gestureRecognizer : UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    // Action of changing date
    @objc func dateChanged(datePicker : UIDatePicker){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
        DTAddActivitytextfield.text = dateFormat.string(from: datePicker.date)
    }
    
    // Action of changing duration
    @objc func dateChanged1(datePicker : UIDatePicker){
        let dateFormat = DateFormatter()
        dateFormat.timeStyle = .medium
        DurationActivitytextfield.text = String(Int(durationPicker.countDownDuration / 60))
    }
}