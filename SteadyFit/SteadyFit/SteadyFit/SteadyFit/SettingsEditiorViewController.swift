//
//  SettingsEditiorViewController.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-11-04.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Alexa Chen, Yimin Long
//  List of Changes: User can edit their profile
//
//  Edited by: Dickson Chum
//  List of Changes: implemented logout feature with Firebase
//
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SettingsEditiorViewController: EmergencyButtonViewController {
    
    var ref:DatabaseReference?
    var refHandle:DatabaseHandle?
    let currentuserID = (Auth.auth().currentUser?.uid)!
    var currentUserCity: String?
    var currentUserProvince: String?
    var currentUserActivityLevel: String?
    var currentUserGender: String?
    var currentUserBio: String?
    var currentUserBirthday: String?
    
    

    @IBOutlet var editProfileDatePicker: UITextField!
    let datePicker = UIDatePicker()
    
    @IBAction func BirthdayTextField(_ sender: UITextField) {
    }
    
    @IBAction func CityTextField(_ sender: UITextField) {
    }
    
    @IBOutlet weak var cityTextBox: UITextField!
    let cityList = ["Burnaby", "Vancouver", "Surrey", "Coquitlam", "Richmond"]
    var selectCity: String?
    let cityPicker = UIPickerView()
    
    @IBAction func ProvinceTextField(_ sender: UITextField) {
    }
    @IBOutlet weak var provinceTextBox: UITextField!
    let provinceList = ["BC"]
    var selectProvince: String?
    let provincePicker = UIPickerView()
    
    @IBAction func ActivityLevelTextField(_ sender: UITextField) {
    }
    @IBOutlet weak var activityLevelTextBox: UITextField!
    let levelList = ["Light", "Very light", "Moderate", "Intense", "Very intense"]
    var selectLevel: String?
    let levelPicker = UIPickerView()
    
    @IBAction func BioTextField(_ sender: UITextField) {
    }
    @IBOutlet weak var bioTextBox: UITextField!
    
    @IBAction func GenderTextField(_ sender: UITextField) {
    }
    
    @IBOutlet weak var genderTextBox: UITextField!
    let genderList = ["F", "M", "U"]
    var selectGender: String?
    let genderPicker = UIPickerView()
    
    // Logout action when logoutButton is clicked, present loginViewController when user is logged out
    @IBAction func logoutButton(_ sender: UIButton) {
        print("Before logout, User is ", Auth.auth().currentUser as Any)
        do{
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        print("After logout, User is ", Auth.auth().currentUser as Any)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var nameLabel: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creatDatePicker()
        creatCityPicker()
        creatCityToolBar()
        creatProvincePicker()
        creatLevelPicker()
        creatGenderPicker()
        
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
        self.ref!.child("Users").child(currentuserID).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let userDictionary = snapshot.value as? [String: AnyObject]
            print (snapshot)
            
            if userDictionary != nil{
                self.currentUserCity = userDictionary!["city"] as? String
                self.currentUserProvince = userDictionary!["province"] as? String
                self.currentUserActivityLevel = userDictionary!["activitylevel"] as? String
                self.currentUserGender = userDictionary!["gender"] as? String
                self.currentUserBio = userDictionary!["description"] as? String
                self.currentUserBirthday = userDictionary!["birthdate"] as? String
            }
            DispatchQueue.main.async{
                self.cityTextBox.text = self.currentUserCity
                self.provinceTextBox.text = self.currentUserProvince
                self.activityLevelTextBox.text = self.currentUserActivityLevel
                self.genderTextBox.text = self.currentUserGender
                self.bioTextBox.text = self.currentUserBio
                self.editProfileDatePicker.text = self.currentUserBirthday
            }
            
        })
        
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        //        writeToFirebace()
        if cityTextBox.text != nil && editProfileDatePicker.text != nil && provinceTextBox.text != nil && activityLevelTextBox.text != nil && genderTextBox.text != nil && bioTextBox.text != nil{
            let newUserInfo = ["/Users/\(currentuserID)/birthdate": editProfileDatePicker.text,
                               "/Users/\(currentuserID)/city": cityTextBox.text,
                               "/Users/\(currentuserID)/province": provinceTextBox.text,
                               "/Users/\(currentuserID)/activitylevel": activityLevelTextBox.text,
                               "/Users/\(currentuserID)/gender": genderTextBox.text,
                               "/Users/\(currentuserID)/description": bioTextBox.text
                ] as [String:Any]
            ref?.updateChildValues(newUserInfo)
            navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    //Birthday date picker
    func creatDatePicker()
    {
        editProfileDatePicker.inputView = datePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClick))
        toolbar.setItems([doneButton], animated: true)
        editProfileDatePicker.inputAccessoryView = toolbar
        
        datePicker.datePickerMode = .date
    }
    
    @objc func doneClick()
    {
        let editDateFormatter = DateFormatter()
        editDateFormatter.dateFormat = "yyyy-MM-dd"
        editProfileDatePicker.text = editDateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    // City picker
    func creatCityPicker()
    {
        cityPicker.delegate = self
        cityTextBox.inputView = cityPicker
    }
    
    func creatProvincePicker()
    {
        provincePicker.delegate = self
        provinceTextBox.inputView = provincePicker
    }
    
    func creatLevelPicker()
    {
        levelPicker.delegate = self
        activityLevelTextBox.inputView = levelPicker
    }
    
    func creatGenderPicker()
    {
        genderPicker.delegate = self
        genderTextBox.inputView = genderPicker
    }
    
    func creatCityToolBar()
    {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SettingsEditiorViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        cityTextBox.inputAccessoryView = toolBar
        provinceTextBox.inputAccessoryView = toolBar
        activityLevelTextBox.inputAccessoryView = toolBar
        genderTextBox.inputAccessoryView = toolBar
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

extension SettingsEditiorViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        
        if (pickerView === cityPicker)
        {
            return cityList.count
        }
            
        else if(pickerView === provincePicker)
        {
            return provinceList.count
        }
            
        else if(pickerView === levelPicker)
        {
            return levelList.count
        }
            
        else if(pickerView === genderPicker)
        {
            return genderList.count
        }
        else
        {
            return 2
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if (pickerView === cityPicker)
            
        {
            return cityList[row]
        }
            
        else if(pickerView === provincePicker)
        {
            return provinceList[row]
        }
            
        else if(pickerView === levelPicker)
        {
            return levelList[row]
        }
            
        else if(pickerView === genderPicker)
        {
            return genderList[row]
        }
        else {
            return "N"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        if (pickerView === cityPicker)
        {
            selectCity = cityList[row]
            cityTextBox.text = selectCity
        }
        else if(pickerView === provincePicker)
        {
            selectProvince = provinceList[row]
            provinceTextBox.text = selectProvince
        }
        else if(pickerView === levelPicker)
        {
            selectLevel = levelList[row]
            activityLevelTextBox.text = selectLevel
        }
            
        else if(pickerView === genderPicker)
        {
            selectGender = genderList[row]
            genderTextBox.text = selectGender
            
        }
    }
}

