//
//  AddEventViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-11-14.
//  Copyright © 2018 Daycar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class AddEventViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var durationTextField: UITextField!
    /*------------------database stuff-----------*/
    var ref:DatabaseReference? = Database.database().reference()
    var refHandle:DatabaseHandle?
    var groupID = ""
    var myUserID = (Auth.auth().currentUser?.uid)!
    var myUserName: String = ""
    /*-----------------------------*/
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    var activeTextField : UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        startDateTextField.delegate = self
        durationTextField.delegate = self
        descriptionTextView.delegate = self
        eventNameTextField.delegate = self
        locationTextField.delegate = self
        createDatePicker()
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.text = "Description"
        descriptionTextView.textColor = UIColor.lightGray
        eventNameTextField.layer.borderWidth = 1
        locationTextField.layer.borderWidth = 1
        startDateTextField.layer.borderWidth = 1
        durationTextField.layer.borderWidth = 1
        ref?.child("Users").child(myUserID).child("name").observeSingleEvent(of: .value, with: {(snapshot) in
            self.myUserName = (snapshot.value as? String)!
        })
    }

    @IBAction func saveButton(_ sender: Any) {
        //function: save the information into the database
        //redirect to the group page:done
        //
        let key:String = (ref!.child("Activities_Events").childByAutoId().key)!
        let post = ["Participants": [myUserID: ["name": myUserName]],
                    "date": startDateTextField.text ?? "nothing",
                    "event_name": eventNameTextField.text ?? "nothing",
                    "description": descriptionTextView.text,
                    "duration_minute": durationTextField.text ?? "nothing",
                    "groupid": groupID, //have to grav this from somewhere
                    "intensity": 3, //have to grab this from somewhere
                    "isPersonal": 0,
                    "location": locationTextField.text ?? "nothing"
            ] as [String : Any]
        
        let childUpdates = ["/Activities_Events/\(key)/": post]
        ref?.updateChildValues(childUpdates)
        //====
        /*let newParticipantPost = ["name": myUserName]
        var currentSessionId: String?
        let addParticipant = ["/Activities_Events/\(currentSessionId)/Participants/\(myUserID)/" : newParticipantPost]*/
        //=====
        //goes back to previous view controller
        navigationController?.popViewController(animated: true)
    }

    func createDatePicker(){
        startDateTextField.inputView = startDatePicker
        endDatePicker.datePickerMode = .countDownTimer
        durationTextField.inputView = endDatePicker
        let datePickerToolBar = UIToolbar()
        datePickerToolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        datePickerToolBar.setItems([doneButton], animated: true)
        startDateTextField.inputAccessoryView = datePickerToolBar
        durationTextField.inputAccessoryView = datePickerToolBar
    }
    
   @objc func doneClicked() {
        let startDateFormat = DateFormatter()
        let durationDateFormat = DateFormatter()
        durationDateFormat.timeStyle = .medium
        startDateFormat.dateFormat = "yyyy-MM-dd HH:mm"
        if(activeTextField == startDateTextField){
            startDateTextField.text = startDateFormat.string(from: startDatePicker.date)
        }
        else{
            durationTextField.text = String(Int(endDatePicker.countDownDuration / 60))
        }
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(textField == durationTextField){
            durationTextField.text = durationTextField?.text ?? "5" + "minutes"
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        durationTextField.resignFirstResponder()
        eventNameTextField.resignFirstResponder()
        startDateTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            descriptionTextView.resignFirstResponder()
            return false
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        if(textView == descriptionTextView){
            moveTextView(textView, moveDistance: -250, up: true)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        moveTextView(textView, moveDistance: -250, up: false)
    }
    func moveTextView(_ textView: UITextView, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}
