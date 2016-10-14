//
//  GroupViewController.swift
//  musifinder
//
//  Created by Paul Beneteau on 06/10/2016.
//  Copyright © 2016 TastyApptastyapp. All rights reserved. ????
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref = FIRDatabase.database().reference()
    var user = FIRAuth.auth()?.currentUser
    var selectedMode: String = "soft"
    var userNameAdd: String!
    var userIDAdd: String!
    var userTab = [User]()
    
    
    @IBOutlet weak var groupNameField: UITextField!
    @IBOutlet weak var userIDField: UITextField!
    
    @IBOutlet weak var modeView: UIView!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var softButton: UIButton!
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var foundNameLabel: UILabel!
    
    @IBOutlet weak var playerView: UIView!
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameView.hidden = false
        modeView.hidden = true
        playerView.hidden = true
        colorView.hidden = true
        userTab = []
        userTab.removeAll()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CreateGroup(sender: AnyObject) {
        let groupName: String = (groupNameField.text!)
        let groupID = NSUUID().UUIDString
        
        if groupName == "" { // regarder avec textVide
            print("need to enter a group name")
        } else {
            self.ref.child("user_groups").child("\(groupName)").child("ID").setValue(groupID)
            self.ref.child("user_groups").child("\(groupName)").child("mode").setValue(selectedMode)
            self.ref.child("user_groups").child("\(groupName)").child("members").child("\(user!.uid)").setValue(user!.displayName)
            self.ref.child("user_profile").child(user!.uid).child("groups").child(groupName).setValue(groupID)
            print("group added successfuly")
            
           
            
            if userTab.count != 0 {
                for user in userTab {
                    self.ref.child("user_groups").child("\(groupName)").child("members").child("\(userIDAdd)").setValue(user.name)
                    self.ref.child("user_profile").child(userIDAdd).child("groups").child(groupName).setValue(groupID)
                    print("Extra user \(user.name) added successfuly!")
                }
            }
            
            
        }
        
        
        
    }
    
    @IBAction func addPlayer(sender: AnyObject) {
        
        print(userIDField.text!)
        ref.child("user_profile").child(userIDField.text!).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if !snapshot.exists() { return }
            
            if let userName = snapshot.value!["name"] as? String {
                print(userName)
                self.foundNameLabel.text = userName
                self.userNameAdd = userName
                self.userIDAdd = self.userIDField.text
                self.userIDField.text = ""
                
                let user = User(name: userName, id: "\(self.userIDField.text)")
                
                
                self.userTab.append(user)
                self.tableView.reloadData()
            }
            
        })
        
    }
    
    @IBAction func hardButtonAction(sender: AnyObject) {
        self.hardButton.setImage(UIImage(named: "hard button selected"), forState: .Normal)
        self.softButton.setImage(UIImage(named: "soft button deselected"), forState: .Normal)
        selectedMode = "hard"
        
    }
    @IBAction func softButtonAction(sender: AnyObject) {
        self.hardButton.setImage(UIImage(named: "hard button deselected"), forState: .Normal)
        self.softButton.setImage(UIImage(named: "soft button selected"), forState: .Normal)
        selectedMode = "soft"
        
    }
   
    @IBAction func modeBackAction(sender: AnyObject) {
        nameView.hidden = false
        modeView.hidden = true
        playerView.hidden = true
        colorView.hidden = true
    }
    @IBAction func nameNextAction(sender: AnyObject) {
        nameView.hidden = true
        modeView.hidden = false
        playerView.hidden = true
        colorView.hidden = true
    }
    @IBAction func modeNextAction(sender: AnyObject) {
        nameView.hidden = true
        modeView.hidden = true
        playerView.hidden = false
        colorView.hidden = true
    }
    
    @IBAction func playerBackButton(sender: AnyObject) {
        nameView.hidden = true
        modeView.hidden = false
        playerView.hidden = true
        colorView.hidden = true
    }
    @IBAction func playerNextAction(sender: AnyObject) {
        nameView.hidden = true
        modeView.hidden = true
        playerView.hidden = true
        colorView.hidden = false
    }

    @IBAction func colorBackAction(sender: AnyObject) {
        nameView.hidden = true
        modeView.hidden = true
        playerView.hidden = false
        colorView.hidden = true
    }
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTab.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        (cell.viewWithTag(101) as! UILabel).text = userTab[indexPath.row].name
        
        return cell
    }
    
}
