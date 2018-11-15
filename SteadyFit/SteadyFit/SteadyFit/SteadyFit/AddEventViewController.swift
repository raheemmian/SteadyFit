//
//  AddEventViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-11-14.
//  Copyright © 2018 Daycar. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    var activeTextField : UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        descriptionTextView.delegate = self
        eventNameTextField.delegate = self
        locationTextField.delegate = self
        self.createDatePicker()
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.text = "Description"
        descriptionTextView.textColor = UIColor.lightGray
        eventNameTextField.layer.borderWidth = 1
        locationTextField.layer.borderWidth = 1
        startDateTextField.layer.borderWidth = 1
        endDateTextField.layer.borderWidth = 1
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    @IBAction func saveButton(_ sender: Any) {
        //save the information into the database
        //redirect to the group page
        //
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            descriptionTextView.resignFirstResponder()
            return false
        }
        return true
    }
    func createDatePicker(){
        startDateTextField.inputView = startDatePicker
        endDateTextField.inputView = endDatePicker
        let datePickerToolBar = UIToolbar()
        datePickerToolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        datePickerToolBar.setItems([doneButton], animated: true)
        startDateTextField.inputAccessoryView = datePickerToolBar
        endDateTextField.inputAccessoryView = datePickerToolBar
    }
    
   @objc func doneClicked() {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.timeStyle = .short
        if activeTextField == startDateTextField {
            startDateTextField.text = dateFormat.string(from: startDatePicker.date)
        } else if activeTextField == endDateTextField {
           endDateTextField.text = dateFormat.string(from: endDatePicker.date)
        }
        self.view.endEditing(true)
        
    }
}
