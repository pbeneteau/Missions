//
//  LoginViewController.swift
//  musifinder
//
//  Created by Paul Beneteau on 20/09/2016.
//  Copyright © 2016 TastyApp. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase


class LoginViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var signInViewButton: UIButton!
    @IBOutlet weak var newAccountViewButton: UIButton!
   
    let customPresentAnimationController = CustomPresentAnimationController()
    
    override func viewDidLoad() {
        if let user = FIRAuth.auth()?.currentUser  {
            print("user already logged in")
            Helper.helper.switchToNavigationController()
            
        }
        self.signInViewButton.backgroundColor = UIColor.clearColor()
        self.signInViewButton.layer.borderWidth = 0.7
        self.signInViewButton.layer.borderColor = UIColor(red:0.5, green:1.00, blue:1.00, alpha: 0.3).CGColor
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "loginTosignIn" {
            let toViewController = segue.destinationViewController as UIViewController
            toViewController.transitioningDelegate = self
        }
        
        if segue.identifier == "logInToSignUp" {
            let toViewController = segue.destinationViewController as UIViewController
            toViewController.transitioningDelegate = self
        }

    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customPresentAnimationController
    }
    

    

}

