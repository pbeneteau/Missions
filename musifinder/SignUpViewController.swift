//
//  SignUpViewController.swift
//  musifinder
//
//  Created by Paul Beneteau on 29/09/2016.
//  Copyright © 2016 TastyApptastyapp. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase


class SignUpViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, FBSDKLoginButtonDelegate {

    @IBOutlet weak var eMailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var googleSignIn: UIButton!
  
    
    var ref: FIRDatabaseReference!
    let loginButton: FBSDKLoginButton? = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        GIDSignIn.sharedInstance().clientID = "994352175358-oo31rsnctt8989pkpqm3ghutgolb7p9f.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    
    /////////FACEBOOK SIGNIN//////////
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            print(error.localizedDescription)
            return
            
        } else if (result.isCancelled){
            print("user canceled sign up")
        } else {
            print("logging in...")
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                } else {
                    print("user logged in with facebook")
                }
                
            })
        }}
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
        
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        try!FIRAuth.auth()?.signOut()
        print("user did logout of facebook")
    }
    //////////////////////////////////
    
    
    
    /////////EMAIL SIGNIN/////////////
    @IBAction func emailLoginAction(sender: AnyObject) {
        print("Continue button tapped")
       LoginWithEmail()
        Helper.helper.switchToNavigationController()
    }
    
    
    func LoginWithEmail() {
        FIRAuth.auth()?.signInWithEmail(eMailField.text!, password: passwordField.text!, completion:
            {
                user, error in
                
                if error != nil {
                    print("Incorrect")
                } else {
                    print("logged in")
                    
                }})
    }
    ////////////////////////////////// 
    
    
    /////////GOOGLE SIGNIN////////////
    @IBAction func googleLogin(sender: AnyObject) {
        print("login google did tapped")
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if error != nil {
            print(error!.localizedDescription)
            return
        }
        print(user.authentication)
        loginWithGoogle(user.authentication)
        }
    
    func loginWithGoogle(authentification: GIDAuthentication) {
        
        let credentials = FIRGoogleAuthProvider.credentialWithIDToken(authentification.idToken, accessToken: authentification.accessToken)
        FIRAuth.auth()?.signInWithCredential(credentials, completion: {
            
            (user: FIRUser?, error: NSError?) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }else {
                
                Helper.helper.switchToNavigationController()
            }
        })
        
    }
    //////////////////////////////////
    
    
    
    /////////KEYBOARD ACTION//////////
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
            else {
                
            }
        }
        
    }
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
            else {
                
            }
        }
    }
      @IBAction func mailEdit(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignInViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    @IBAction func passwordEdit(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignInViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignInViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        
    }
    //////////////////////////////////
    
    
    func addCredentialToDatabase() {
        ref = FIRDatabase.database().reference()
    }
    
    
    @IBAction func dismiss(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
