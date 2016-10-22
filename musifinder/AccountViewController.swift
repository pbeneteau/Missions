//
//  AccountViewController.swift
//  musifinder
//
//  Created by Paul Beneteau on 25/09/2016.
//  Copyright © 2016 TastyApptastyapp. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage



class AccountViewController: UIViewController{
    var ref = FIRDatabase.database().reference()
    
    
    
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var uiimvProfilePic: UIImageView!
    @IBOutlet weak var lougoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     

        
        self.uiimvProfilePic.layer.cornerRadius = self.uiimvProfilePic.frame.size.width/2
        self.uiimvProfilePic.clipsToBounds = true
        
        if let user = FIRAuth.auth()?.currentUser {
            // User is signed in.
            let name = user.displayName
            let email = user.email
            
            self.userName.text = name
            self.userEmail.text = email
            let userID = FIRAuth.auth()?.currentUser?.uid
            
            ref.child("user_profile").child(user.uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if !snapshot.exists() { return }
        
                
                if let userName = snapshot.value!["name"] as? String {
                    print(userName)
                }
                if let email = snapshot.value!["email"] as? String {
                    print(email)
                }
                
                // can also use
            })
            
            //reference to storage service
            let storage = FIRStorage.storage()
            //reference to particular storage service
            
            let storageRef = storage.referenceForURL("gs://missions-app.appspot.com/")
            let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg")

            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            profilePicRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                
                if (error != nil) {
                    print("Unbale to download image")
                    
                } else {
           
                    if(data != nil) {
                        self.uiimvProfilePic.image = UIImage(data: data!)
                    }
                }
            }
            
            
            if (self.uiimvProfilePic.image == nil) {
                
            
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
                        self.uiimvProfilePic.image = UIImage(data:imageData)
                    }
                    
                }
            })
        }
            
        } else {
            // No user is signed in.
        }
        
 
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logoutAction(sender: AnyObject) {
        // sign user out of firebase
        try! FIRAuth.auth()?.signOut()
        // sign user out of facebook
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginViewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LogInVC")
        self.presentViewController(LoginViewController, animated: true, completion: nil)
    }
    

   }
