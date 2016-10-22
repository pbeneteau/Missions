//
//  GroupInfoViewController.swift
//  musifinder
//
//  Created by Paul Beneteau on 15/10/2016.
//  Copyright © 2016 tastyapp. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class GroupInfoViewController: UIViewController {
    
    @IBOutlet weak var groupName: UILabel!
  
    var ref = FIRDatabase.database().reference()
    var user = FIRAuth.auth()?.currentUser
    var itemId: String!
    var groupMembers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let groupNameL = itemId
        
        groupName.text = groupNameL
        
        ref.child("user_groups").child(itemId).child("members").observeEventType(.Value, withBlock: {
            snapshot in
            
            for group in snapshot.children {
                self.groupMembers.append(group.key)
                print(self.groupMembers)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dismiss(sender: UIButton) {
         dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
