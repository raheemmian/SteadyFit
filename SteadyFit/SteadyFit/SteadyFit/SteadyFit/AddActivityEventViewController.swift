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
    
    
    
    private var datePicker: UIDatePicker?
    private var durationPicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NameActivityTextField.delegate = self
        DescriptionActivitytextfield.delegate = self
        
        //DTfield
        datePicker=UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(AddActivityEventViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddActivityEventViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
    DTAddActivitytextfield.inputView=datePicker
    //DTfield
        //Durationfield
        durationPicker = UIDatePicker()
        durationPicker?.datePickerMode = .countDownTimer
        durationPicker?.addTarget(self, action: #selector(AddActivityEventViewController.dateChanged1(datePicker:)), for: .valueChanged)
        
        _ = UITapGestureRecognizer(target: self, action: #selector(AddActivityEventViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        DurationActivitytextfield.inputView=durationPicker
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
        dateFormat.dateFormat = "hh:mm mm/dd/yy"
        DTAddActivitytextfield.text = dateFormat.string(from: datePicker.date)
        
        
    }
    @objc func dateChanged1(datePicker : UIDatePicker){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "hh:mm"
        DurationActivitytextfield.text = dateFormat.string(from: (durationPicker?.date)!)
        
        
    }

}
