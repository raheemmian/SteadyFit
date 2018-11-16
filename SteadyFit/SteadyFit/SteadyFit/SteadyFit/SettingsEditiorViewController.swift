//
//  SettingsEditiorViewController.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-11-04.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Dickson Chum
//  List of Changes: Work in Progress
//  

import UIKit

class SettingsEditiorViewController: UIViewController {

//    var name: String!
//    name = "John Doe"
    
    @IBAction func saveButton(_ sender: UIButton) {
//        writeToFirebace()
    }
    
    
    @IBOutlet var editProfileDatePicker: UITextField!
    let datePicker = UIDatePicker()
    
    @IBAction func BirthdayTextField(_ sender: UITextField) {
    }
   
    @IBAction func CityTextField(_ sender: UITextField) {
    }
    
    @IBAction func ProvinceTextField(_ sender: UITextField) {
    }
    
    @IBAction func ActivityLevelTextField(_ sender: UITextField) {
    }
    
    @IBAction func BioTextField(_ sender: UITextField) {
    }
    
    @IBAction func GenderTextField(_ sender: UITextField) {
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        // logout function
        
    }
    
    //@IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var nameLabel: UIStackView!
    

    
//    func writeToFirebase(){
//
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatDataPicker()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func creatDataPicker()
    {
        editProfileDatePicker.inputView = datePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        toolbar.setItems([doneButton], animated: true)
        editProfileDatePicker.inputAccessoryView = toolbar
    }
    
    func doneClick()
    {
        editProfileDatePicker.text = "\(datePicker.date)"
        self.view.endEditing(true)
    }
    

    
}
