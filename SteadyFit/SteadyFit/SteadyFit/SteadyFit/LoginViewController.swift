//
//  LoginViewController.swift
//  SteadyFit
//
//  Created by Alexa Chen on 2018-11-03.
//  Copyright © 2018 Daycar. All rights reserved.
//modified by Raheem : added error message when the login fails
//This view controller is for email authetication to login into the application


import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var signInRegister: UISegmentedControl!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    var isSignIn:Bool = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignInSelectorChanged(_ sender: UISegmentedControl) {
        isSignIn = !isSignIn
        if isSignIn {
            btnSignIn.setTitle("Sign In", for: .normal)
        }
        else{
            btnSignIn.setTitle("Register", for: .normal)
        }
    }
    
    
    @IBAction func signInButtonClicked(_ sender: UIButton) {
        if let email = txtEmail.text, let pass = txtPassword.text{
            if isSignIn{ // sign in user
                Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                    if let u = user {
                        // user is found, go to home screen
                        self.performSegue(withIdentifier: "GoToHome", sender: self)
                    }
                    else{
                        //error, no existing user
                        self.errorMessage.isHidden = false
                        self.errorMessage.text = "Incorrect email or password"
                        
                    }
                    
                })
            }
            else{ // register user
                Auth.auth().createUser(withEmail: email, password: pass) { (authResult, error) in
                    // ...
                    guard let u = authResult?.user else { return /*error, user is nil*/}
                    //TO DO for version 2: create user in firebase database
    
                    self.performSegue(withIdentifier: "GoToHome", sender: self)
                    
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
