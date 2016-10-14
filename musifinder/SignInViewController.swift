//
//  SignInViewController.swift
//  musifinder
//
//  Created by Paul Beneteau on 28/09/2016.
//  Copyright © 2016 TastyApptastyapp. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase



class SignInViewController: UIViewController,  GIDSignInUIDelegate, GIDSignInDelegate, FBSDKLoginButtonDelegate{
    
    var ref = FIRDatabase.database().reference()
    
    
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookLoginButton!.delegate = self
        facebookLoginButton!.readPermissions = ["public_profile", "email", "user_friends"]
        
        
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
        }
        
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        
        FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            if error == nil {
                
                let storage = FIRStorage.storage()
                
                let storageRef = storage.referenceForURL("gs://missions-app.appspot.com")
                
                let profilePicRef = storageRef.child(user!.uid+"/profile_pic_small.jpg")
                
                let userId = user?.uid
                
                self.ref.child("user_profile").child(userId!).child("profile_pic_small").observeSingleEventOfType(.Value,withBlock: {(snapshot) in
                    let profile_pic = snapshot.value as? String?
                    
                    if(profile_pic == nil) {
                        
                        if let imageData = NSData(contentsOfURL: user!.photoURL!)
                        {
                            let uploadTask = profilePicRef.putData(imageData, metadata: nil) {
                                metadata, error in
                                if (error == nil)
                                {
                                 let downloadURL = metadata!.downloadURL
                                 self.ref.child("user_profile").child("\(user!.uid)/profile_pic_small").setValue(downloadURL()!.absoluteString)
                                 self.ref.child("user_profile").child("\(user!.uid)/name").setValue(user?.displayName)
                                } else {
                                    print("Error in downloading image")
                                }
                            }
                        }
                        
                       
                    } else {
                        print("user logged in earlier")
                    }
                })
                
            }
            print("user logged in with facebook with: ")
            print(user!.displayName!)
            print(user!.uid)
            
            self.ref.child("user_profile").child(user!.uid).child("name").setValue(user!.displayName!)
            Helper.helper.switchToNavigationController()
            
        })
    }
    
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
        FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!, completion: {
            user, error in
            
            if error != nil {
                print("logged in")
                Helper.helper.switchToNavigationController()
            } else {
                print("error")
            }
            
            
        })
    }
    
    
    func LoginWithEmail() {
        FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passwordField.text!, completion:
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
    @IBAction func nameEdit(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignInViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
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
