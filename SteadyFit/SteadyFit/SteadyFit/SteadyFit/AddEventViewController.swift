//
//  AddEventViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-11-14.
//  Copyright © 2018 Daycar. All rights reserved.
//  This is to grab user entered information for an event and then write it to the database
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
    @IBOutlet weak var errorLabel: UILabel!
    /*------------------database stuff-----------*/
    var ref:DatabaseReference? = Database.database().reference()
    var refHandle:DatabaseHandle?
    var groupID: String = ""
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
        errorLabel.isHidden = true
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
        /*function: save the information into the database
          redirect to the group page*/
        if((startDateTextField.text?.isEmpty)! || (eventNameTextField.text?.isEmpty)! || groupID == "" || (durationTextField.text?.isEmpty)! || descriptionTextView.text.isEmpty || (locationTextField.text?.isEmpty)!) {
            /*if any of the fields are empty then the error label has to be displayed, otherwise it is hidden
             */
            self.errorLabel.isHidden = false
        }
        else{
            let key:String = (ref!.child("Activities_Events").childByAutoId().key)!
            print(key)
            let post = ["/Activities_Events/\(key)/Participants": [myUserID: ["name": myUserName]],
            "/Activities_Events/\(key)/date": startDateTextField.text ?? "nothing",
            "/Activities_Events/\(key)/event_name": eventNameTextField.text ?? "nothing",
            "/Activities_Events/\(key)/description": descriptionTextView.text,
            "/Activities_Events/\(key)/duration_minute": durationTextField.text ?? "nothing",
            "/Activities_Events/\(key)/groupid": groupID,
            "/Activities_Events/\(key)/isPersonal": 0,
            "/Activities_Events/\(key)/location": locationTextField.text ?? "nothing",
            "/Groups/\(groupID)/events/\(key)" : eventNameTextField.text ?? "nothing"
            ] as [String : Any]
            ref?.updateChildValues(post)
            //goes back to previous view controller
            navigationController?.popViewController(animated: true)
        }
    }

    func createDatePicker(){
        /*this is for the duration and date text fields,
         duration has a countdowntimer scroll view
         and date has a date and time scroll view
         also added a done button for the user to press once the time has been chosen*/
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
    /*when the done button is clicked the time and date will be displayed in the text field*/
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
    /*these functions beliw are for bringing the keyboard done once the user has completed what they wanted to write*/
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
    /*add a animation to move the description text view above the keyboard
     therefore keyboard is no longer hiding the text view
     since there are no placeholders for textview
     have text in the colour of placeholder text in the view
     and then the text is nil once the user starts editing the text view*/
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
