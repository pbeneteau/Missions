//
//  ChatViewController.swift
//  musifinder
//
//  Created by Paul Beneteau on 20/09/2016.
//  Copyright © 2016 TastyApp. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func logoutDidTapped(sender: AnyObject) {
        print("logout did tapped")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let LogInVC = storyBoard.instantiateViewControllerWithIdentifier("LogInVC") as! LoginViewController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = LogInVC
    }

   

}
