//
//  LoginViewController.swift
//  SteadyFit
//
//  Created by Alexa Chen on 2018-11-03.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Modified by Raheem : added error message when the login fails
//
//  Modified by Dickson : added error message when register fails, reset errorMessage whenever segmentedControl state is changed.
//
//  LoginViewController.swift is for email authetication to login or regitster on the application.
//


import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    var ref:DatabaseReference?
    @IBOutlet weak var signInRegister: UISegmentedControl!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    var isSignIn:Bool = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.isHidden = true
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignInSelectorChanged(_ sender: UISegmentedControl) {
        isSignIn = !isSignIn
        if isSignIn {
            self.errorMessage.isHidden = true
            btnSignIn.setTitle("Sign In", for: .normal)
        }
        else{
            self.errorMessage.isHidden = true
            btnSignIn.setTitle("Register", for: .normal)
        }
    }
    
    @IBAction func signInButtonClicked(_ sender: UIButton) {
        if let email = txtEmail.text, let pass = txtPassword.text {
            // Sign in
            if isSignIn {
                Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                    if user != nil {
                        // Login successfully, go to home screen
                        self.performSegue(withIdentifier: "GoToHome", sender: self)
                    }
                    else{
                        // Login error occurs, prompt error message
                        self.errorMessage.isHidden = false
                        self.errorMessage.text = "Incorrect email or password"
                    }
                })
            }
            // Register user
            else{
                Auth.auth().createUser(withEmail: email, password: pass) { (authResult, error) in
                    // Check if email is existing account or not
                    guard let u = authResult?.user else {
                        self.errorMessage.text = "This email is already a SteadyFit account.\nPlease use a non-registered email."
                        self.errorMessage.isHidden = false
                        return
                    }
                    
                    let newUserID = (Auth.auth().currentUser?.uid)!
                    let post = ["email": email,
                                "password": pass] as [String : Any]
                    let childUpdates = ["/Users/\(newUserID)": post]
                    self.ref?.updateChildValues(childUpdates)
                    
                    // Lead to next UI for inputting user info
                    self.performSegue(withIdentifier: "showInitUserInfo", sender: self)
                }
            }
        }
    }
}
