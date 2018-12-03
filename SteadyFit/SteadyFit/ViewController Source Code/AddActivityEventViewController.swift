//
//  AddActivityEventViewController.swift
//  SteadyFit
//
//  Created by Akshay Kumar on 2018-11-09.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Akshay Kumar
//  Implemented textFields
//
//  Edited by: Alexa Chen
//  Implemented save button and write in database
//
//  Edited by: Dickson Chum
//  Implemented done button on keyboard and hide keyboard when it is clicked, added comments
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
    
    // Displays an error if any field is left empty, otherwise sends all the entered data to the database
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
        
        // Keyboard will hide when view is tabbed
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddActivityEventViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        // Setup Data and time field
        datePicker.datePickerMode = .dateAndTime
        DTAddActivitytextfield.inputView = datePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonForDT))
        toolbar.setItems([doneButton], animated: true)
        DTAddActivitytextfield.inputAccessoryView = toolbar
        
        // Setup Duration field
        durationPicker.datePickerMode = .countDownTimer
        DurationActivitytextfield.inputView = durationPicker
        let toolbar2 = UIToolbar()
        toolbar2.sizeToFit()
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonForDuration))
        toolbar2.setItems([doneButton2], animated: true)
        DurationActivitytextfield.inputAccessoryView = toolbar2
        
        ref?.child("Users").child(myUserID).child("name").observeSingleEvent(of: .value, with: {(snapshot) in
            self.myUserName = (snapshot.value as? String)!
        })
    }

    // Set text field as first responder
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Action of tap gesture to hide keyboard
    @objc func viewTapped(gestureRecognizer : UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    // Action of done button for Date and Time field
    @objc func doneButtonForDT(){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
        DTAddActivitytextfield.text = dateFormat.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    // Action of done button for Duration field
    @objc func doneButtonForDuration(){
        let dateFormat = DateFormatter()
        dateFormat.timeStyle = .medium
        DurationActivitytextfield.text = String(Int(durationPicker.countDownDuration / 60))
        view.endEditing(true)
    }
    
}
