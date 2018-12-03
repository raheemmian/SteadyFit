//
//  SettingsHelpViewController.swift
//  SteadyFit
//
//  Created by Yimin on 2018-11-27.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//
//  Edited by: Yimin Long
//  List of change: user can click on questions to see the answers
//
//  SettingsHelpViewController.swift is corresponding to Help section in Setting.
//

import UIKit

class SettingsHelpViewController: EmergencyButtonViewController {
    
    @IBOutlet weak var A1view: UIView!
    @IBOutlet weak var A2view: UIView!
    @IBOutlet weak var A3view: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Click on button to show question1 answer
    @IBOutlet weak var Q1Button: UIButton!
    @IBAction func Q1ButtonPressed(_ sender: Any) {
        if(A1view.isHidden == true)
        {
            A1view.isHidden = false
        }
        else
        {
            A1view.isHidden = true
        }
    }
    
    // Click on button to show question2 answer
    @IBOutlet weak var Q2Button: UIButton!
    @IBAction func Q2ButtonPressed(_ sender: Any) {
        if(A2view.isHidden == true)
        {
            A2view.isHidden = false
        }
        else
        {
            A2view.isHidden = true
        }
    }
    
    // Click on button to show question2 answer
    @IBOutlet weak var Q3Button: UIButton!
    @IBAction func Q3ButtonPressed(_ sender: Any) {
        if(A3view.isHidden == true)
        {
            A3view.isHidden = false
        }
        else
        {
            A3view.isHidden = true
        }
    }
}
