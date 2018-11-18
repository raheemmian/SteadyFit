//
//  AddActivityEventViewController.swift
//  SteadyFit
//
//  Created by Maha Javed on 2018-11-09.
//  Copyright © 2018 Daycar. All rights reserved.
//

import UIKit

class AddActivityEventViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var DTAddActivitytextfield: UITextField!
    @IBOutlet weak var DurationActivitytextfield: UITextField!
    @IBOutlet weak var NameActivityTextField: UITextField!
    @IBOutlet weak var DescriptionActivitytextfield: UITextField!
    
    
    
    let datePicker = UIDatePicker()
    let durationPicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NameActivityTextField.delegate = self
        DescriptionActivitytextfield.delegate = self
        
        //DTfield
      //  datePicker=UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
            DTAddActivitytextfield.inputView=datePicker
        datePicker.addTarget(self, action: #selector(AddActivityEventViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddActivityEventViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        

    //DTfield
        //Durationfield
       // durationPicker = UIDatePicker()
        durationPicker.datePickerMode = .countDownTimer
        DurationActivitytextfield.inputView = durationPicker
        durationPicker.addTarget(self, action: #selector(AddActivityEventViewController.dateChanged1(datePicker:)), for: .valueChanged)
        
        _ = UITapGestureRecognizer(target: self, action: #selector(AddActivityEventViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        
    //Durationfield
    //Inputs in String format
        var name: String? = NameActivityTextField.text
        var Description: String? = DescriptionActivitytextfield.text
        var Datetime: String? = DTAddActivitytextfield.text
        var Duration: String? = DurationActivitytextfield.text
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
    
    @objc func viewTapped(gestureRecognizer : UITapGestureRecognizer){
        view.endEditing(true)
        
    }
    
    
    @objc func dateChanged(datePicker : UIDatePicker){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
        DTAddActivitytextfield.text = dateFormat.string(from: datePicker.date)
        
        
    }
    @objc func dateChanged1(datePicker : UIDatePicker){
        let dateFormat = DateFormatter()
        dateFormat.timeStyle = .medium
        DurationActivitytextfield.text = String(Int(durationPicker.countDownDuration / 60))
        
        
    }


}
