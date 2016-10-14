//
//  Helper.swift
//  musifinder
//
//  Created by Paul Beneteau on 20/09/2016.
//  Copyright © 2016 TastyApp. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit
import GoogleSignIn

class Helper {
    static let helper = Helper()



     func switchToNavigationController() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let naviVC = storyBoard.instantiateViewControllerWithIdentifier("FirstExampleVC")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = naviVC
        
    }
    
  
}





