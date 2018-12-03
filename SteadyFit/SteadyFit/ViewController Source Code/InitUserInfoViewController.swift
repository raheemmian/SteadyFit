//
//  InitUserInfoViewController.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-11-18.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Modified by: Alexa Chen, Dickson Chum
//  implemented UI and database writing logic for registering new user info, added Done button, implemeted scroll view for birthday input
//
//  Fixed Bugs:
//  UI constraint issues with the save button in shorter iPhone screens
//  user could potentially input the wrong format for date, activity level etc.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class InitUserInfoViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref:DatabaseReference? = Database.database().reference()
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var activityLevelTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var emergencyContactTextField: UITextField!
    @IBOutlet weak var personalBioTextView: UITextView!
    var activeTextField : UITextField!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    var currentUserPassword: String?
    var currentUserEmail: String?
    var activityLevelList = ["", "Very light", "Light", "Moderate", "Intense", "Very intense"]
    var activityLevelPicker = UIPickerView()
    var provinceList = ["", "BC"]
    var provincePicker = UIPickerView()
    var cityList = ["", "Vancouver", "Burnaby", "Coquitlam", "Surrey", "Richmond"]
    var cityPicker = UIPickerView()
    var genderList = ["", "Male", "Female", "Prefer not to say"]
    var genderPicker = UIPickerView()
    var birthdatePicker = UIDatePicker()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        /* returns the number of rows in the specified picker view*/
        if pickerView == activityLevelPicker{
            return activityLevelList.count
        }
        else if pickerView == provincePicker{
            return provinceList.count
        }
        else if pickerView == cityPicker{
            return cityList.count
        }
        else{
            return genderList.count
        }
    }
    
    func createPicker(){
        /*create UI picker lists for data inputs with restricted format*/
        let pickerToolBar = UIToolbar()
        pickerToolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        pickerToolBar.setItems([doneButton], animated: true)
        activityLevelTextField.inputAccessoryView = pickerToolBar
        provinceTextField.inputAccessoryView = pickerToolBar
        cityTextField.inputAccessoryView = pickerToolBar
        genderTextField.inputAccessoryView = pickerToolBar
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        /*load the selected data from the pickers to the corresponding text fields*/
        if pickerView == activityLevelPicker {
            activityLevelTextField.text = activityLevelList[row]
        }
        else if pickerView == provincePicker{
            provinceTextField.text = provinceList[row]
        }
        else if pickerView == cityPicker{
            cityTextField.text = cityList[row]
        }
        else{
            genderTextField.text = genderList[row]
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        /*returns the selected data for the corresponding picker - specified by the input param pickerView*/
        if pickerView == activityLevelPicker{
            return activityLevelList[row]
        }
        else if pickerView == provincePicker{
            return provinceList[row]
        }
        else if pickerView == cityPicker{
            return cityList[row]
        }
        else{
            return genderList[row]
        }
    }
    
    
    @IBAction func saveInitUserInfo(_ sender: Any) {
        /*save the necessary information of the newly registered user into database*/
        let currentUserID = (Auth.auth().currentUser?.uid)!
        
        if userNameTextField.text != nil && provinceTextField.text != nil && cityTextField.text != nil && activityLevelTextField.text != nil && birthDateTextField.text != nil && genderTextField.text != nil && emergencyContactTextField.text != nil && personalBioTextView.text != nil &&
            userNameTextField.text != "Full name" && provinceTextField.text != "Province" && cityTextField.text != "City" && activityLevelTextField.text != "Activity level" && birthDateTextField.text != "Birth date" && genderTextField.text != "Gender" && emergencyContactTextField.text != "Emergency contact number" && personalBioTextView.text != "Personal bio"{
            errorMessageLabel.text = ""
            let post = ["/Users/\(currentUserID)/name": userNameTextField.text ?? "no name",
                        "/Users/\(currentUserID)/province": provinceTextField.text ?? "BC",
                        "/Users/\(currentUserID)/city": cityTextField.text ?? "Vancouver",
                        "/Users/\(currentUserID)/activitylevel": activityLevelTextField.text ?? "Moderate",
                        "/Users/\(currentUserID)/birthdate": birthDateTextField.text as Any,
                        "/Users/\(currentUserID)/gender": genderTextField.text as Any,
                        "/Users/\(currentUserID)/emergencycontact": emergencyContactTextField.text as Any,
                        "/Users/\(currentUserID)/description": personalBioTextView.text
                ] as [String : Any]
            ref?.updateChildValues(post)
            self.performSegue(withIdentifier: "InitGoToHome", sender: self)
        }
        else{
            errorMessageLabel.text = "*MISSING INFO*"
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userNameTextField.delegate = self
        provinceTextField.delegate = self
        cityTextField.delegate = self
        activityLevelTextField.delegate = self
        birthDateTextField.delegate = self
        genderTextField.delegate = self
        emergencyContactTextField.delegate = self
        personalBioTextView.delegate = self
        
        activityLevelPicker.delegate = self
        provincePicker.delegate = self
        genderPicker.delegate = self
        cityPicker.delegate = self
        provinceTextField.inputView = provincePicker
        cityTextField.inputView = cityPicker
        activityLevelTextField.inputView = activityLevelPicker
        genderTextField.inputView = genderPicker
        createPicker()
        createDatePicker()
        
        personalBioTextView.text = "personal bio"
        personalBioTextView.textColor = UIColor.lightGray
        personalBioTextView.layer.borderWidth = 1
        personalBioTextView.layer.borderWidth = 1
        personalBioTextView.layer.borderWidth = 1
        personalBioTextView.layer.borderWidth = 1
        errorMessageLabel.text = ""
    }
    
    func createDatePicker(){
        /*create the date picker for birthday text field*/
        birthdatePicker.datePickerMode = .date
        birthDateTextField.inputView = birthdatePicker
        let datePickerToolBar = UIToolbar()
        datePickerToolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        datePickerToolBar.setItems([doneButton], animated: true)
        birthDateTextField.inputAccessoryView = datePickerToolBar
    }
    
    @objc func doneClicked() {
        /*executed when "Done" button is clicked for the birth date picker*/
        if activeTextField == birthDateTextField{
            let startDateFormat = DateFormatter()
            startDateFormat.dateFormat = "yyyy-MM-dd"
            birthDateTextField.text = startDateFormat.string(from: birthdatePicker.date)
        }
        self.view.endEditing(true)
    }
    
    //===================
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //resigning the keyboard if something outside of the text field that is active is pressed
        userNameTextField.resignFirstResponder()
        provinceTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        activityLevelTextField.resignFirstResponder()
        birthDateTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
        emergencyContactTextField.resignFirstResponder()
        personalBioTextView.resignFirstResponder()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //pressing return resigns the keyboard
        if(text == "\n") {
            personalBioTextView.resignFirstResponder()
            return false
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        //getting rid of the place holder text in the text view
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        //moving the text view above the keyboard
        if(textView == personalBioTextView){
            moveTextView(textView, moveDistance: -250, up: true)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        //move the scene back down to original place
        moveTextView(textView, moveDistance: -250, up: false)
    }
    func moveTextView(_ textView: UITextView, moveDistance: Int, up: Bool) {
        //provides the animation of moving the page up so that both keyboard
        //and the text view are scene
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}
