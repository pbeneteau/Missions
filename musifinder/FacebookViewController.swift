//  FacebookViewController.swift
//  musifinder
//
//  Created by Paul Beneteau on 20/09/2016.
//  Copyright © 2016 TastyAppp. All rights reserved.
//


import UIKit
import GoogleSignIn
import FBSDKLoginKit


class FacebookViewController: UIViewController, FBSDKLoginButtonDelegate {
 
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("user logged in")
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user did logout")
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    

}