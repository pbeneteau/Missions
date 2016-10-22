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
import FirebaseStorage




class SignInViewController: UIViewController,  GIDSignInUIDelegate, GIDSignInDelegate, FBSDKLoginButtonDelegate{
    
    var ref = FIRDatabase.database().reference()
    
    
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var activityView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.hidden = true
        activityView.layer.cornerRadius = 10
        activityView.clipsToBounds = true
        
        userNameLabel.text = ""
        facebookLoginButton!.delegate = self
        facebookLoginButton!.readPermissions = ["public_profile", "email", "user_friends"]
        
        facebookLoginButton.layer.shadowColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0).CGColor
        facebookLoginButton.layer.shadowOpacity = 0.5
        facebookLoginButton.layer.shadowOffset = CGSizeMake(0, 1)
        facebookLoginButton.layer.shadowRadius = 1
        facebookLoginButton.layer.shadowPath = UIBezierPath(rect: facebookLoginButton.bounds).CGPath
        
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
        activityView.hidden = false
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
                                print("WELCOME")
                                
                                let userName: String = user!.displayName!
                                self.userNameLabel.text = "Welcome, \(userName)"
                                 
                                    let profilePic = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height": 300, "width": 300, "redirect": false], HTTPMethod: "GET")
                                    profilePic.startWithCompletionHandler({(connection, result, error) -> Void in
                                        if error == nil {
                                            let dictionary = result as? NSDictionary
                                            let data = dictionary?.objectForKey("data")
                                            let urlPic = (data?.objectForKey("url"))! as? String
                                            
                                            if let imageData = NSData(contentsOfURL: NSURL(string: urlPic!)!)
                                            {
                                                
                                                let uploadTask = profilePicRef.putData(imageData, metadata: nil){
                                                    metadata,error in
                                                    if error == nil {
                                                        let downloadURL = metadata!.downloadURL
                                                    } else {
                                                        print("error in downloading image")
                                                    }
                                                }
                                                
                                                self.userProfilePic.image = UIImage(data:imageData)
                                                self.userProfilePic.layer.cornerRadius = self.userProfilePic.frame.size.width/2
                                                self.userProfilePic.clipsToBounds = true
                                                
                                            }
                                            
                                        }
                                    })
                                    
                                
                                 self.activityView.hidden = true
                                let triggerTime = (Int64(NSEC_PER_SEC) * 3)
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                                Helper.helper.switchToNavigationController()
                                
                                })
                                    
                                } else {
                                    self.activityView.hidden = true
                                    print("Error in downloading image")
                                }
                            }
                        }
                        
                       
                    } else {
                        self.activityView.hidden = true
                        print("user logged in earlier")
                        Helper.helper.switchToNavigationController()
                        
                    }
                })
                
            }
            print("user logged in with facebook with: ")
            print(user!.displayName!)
            print(user!.uid)
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
        self.activityView.hidden = false
        print(user.authentication)
        loginWithGoogle(user.authentication)
        
        if error == nil {
            
            let storage = FIRStorage.storage()
            let storageRef = storage.referenceForURL("gs://missions-app.appspot.com")
            let user = FIRAuth.auth()?.currentUser
            
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
        self.activityView.hidden = true
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
    

    
    
    
    @IBAction func dismiss(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
