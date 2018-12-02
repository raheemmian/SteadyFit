//
//  CreatePrivateGroupViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-11-25.
//  Copyright © 2018 Daycar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CreatePrivateGroupViewController: EmergencyButtonViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var activityLevelTextField: UITextField!
    @IBOutlet weak var groupTypeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var errorLabel: UILabel!
    var ref:DatabaseReference? = Database.database().reference()
    var refHandle:DatabaseHandle?
    var groupID: String = ""
    var myUserID = (Auth.auth().currentUser?.uid)!
    var myUserName: String = ""
    var picker = UIPickerView()
    var activityLevelArr = ["Very Light","Light", "Moderate", "Intense", "Very Intense"]
    var groupTypeArr = ["Public", "Private"]
    var activeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextBoxes()
        picker.delegate = self
        picker.dataSource = self
        createPicker()
        activityLevelTextField.inputView = picker
        groupTypeTextField.inputView = picker
        //get user name
        ref?.child("Users").child(myUserID).child("name").observeSingleEvent(of: .value, with: {(snapshot) in
            self.myUserName = (snapshot.value as? String)!
        })
    }
    
    func setTextBoxes() {
        descriptionTextView.text = "Description"
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.layer.borderWidth = 1
        groupNameTextField.layer.borderWidth = 1
        activityLevelTextField.layer.borderWidth = 1
        groupTypeTextField.layer.borderWidth = 1
        locationTextField.layer.borderWidth = 1
        descriptionTextView.delegate = self
        groupNameTextField.delegate = self
        activityLevelTextField.delegate = self
        groupTypeTextField.delegate = self
        locationTextField.delegate = self
        errorLabel.textColor = .red
        errorLabel.isHidden = true
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        if (groupNameTextField.text?.isEmpty)! || (activityLevelTextField.text?.isEmpty)! || (groupTypeTextField.text?.isEmpty)! || (locationTextField.text?.isEmpty)! || (descriptionTextView.text.isEmpty) {errorLabel.isHidden = false}
        else{
            //write to database
            let chatId: String = (ref?.child("Chats").childByAutoId().key)!
            let key: String = (ref?.child("Groups").childByAutoId().key)!
            let post = ["/Groups/\(key)/activitylevel": activityLevelTextField.text!,
                        "/Groups/\(key)/chatid": chatId,
                        "/Groups/\(key)/description": descriptionTextView.text,
                        "/Groups/\(key)/grouptype": groupTypeTextField.text!,
                        "/Groups/\(key)/location": locationTextField.text!,
                        "/Groups/\(key)/name": groupNameTextField.text!,
                        "/Groups/\(key)/users": [myUserID: ["joined": 1, "name":myUserName]],
                        "/Chats/\(chatId)/groupID" : key,
                        "/Users/\(myUserID)/Groups": [key:["chatid": chatId, "grouptype":groupTypeTextField.text!, "name": groupNameTextField.text!]]
                ] as [String : Any]
            ref?.updateChildValues(post)
            navigationController?.popViewController(animated: true)
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeTextField == activityLevelTextField {
            return activityLevelArr.count
        }
        else {
            return groupTypeArr.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeTextField == activityLevelTextField {
            return activityLevelArr[row]
        }
        else {
            return groupTypeArr[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activeTextField == activityLevelTextField {
            activityLevelTextField.text = activityLevelArr[row]
        }
        else {
             groupTypeTextField.text = groupTypeArr[row]
        }
    }
    func createPicker(){
        let PickerToolBar = UIToolbar()
        PickerToolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        PickerToolBar.setItems([doneButton], animated: true)
        activityLevelTextField.inputAccessoryView = PickerToolBar
        groupTypeTextField.inputAccessoryView = PickerToolBar
    }
    
    @objc func doneClicked() {
        self.view.endEditing(true)
    }
    
    /*----------------Resign Keyboard--------------------------*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        groupNameTextField.resignFirstResponder()
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
    /*----------------------------------------------------*/

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
     /*----------------------------------------------------*/
}
