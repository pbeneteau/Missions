//
//  GroupUsersCollectionViewController.swift
//  musifinder
//
//  Created by Paul Beneteau on 11/10/2016.
//  Copyright © 2016 tastyapp. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

private let reuseIdentifier = "UserCollectionViewCell"
private let lastCellIdentifier = "lastCell"

class GroupUsersCollectionViewController: UICollectionViewController, UIViewControllerTransitioningDelegate {
    
    var groupNameCell: String?
    var ref = FIRDatabase.database().reference()
    var usersDict = NSDictionary?()
    var user = FIRAuth.auth()?.currentUser
    var userNamesArray = [String]()
    var userImagesArray = [String]()
    var groupNames = [String]()
    var selectedRow: String = "vide"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ref.child("user_profile").child(user!.uid).child("groups").observeEventType(.Value, withBlock: {
            snapshot in
            
            for group in snapshot.children {
                self.groupNames.append(group.key)
            }
            self.collectionView?.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (self.groupNames.count) + 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        if (indexPath.row == (groupNames.count))
        {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(lastCellIdentifier, forIndexPath: indexPath) as! lastCell
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GUserCollectionViewCell
            
            if indexPath.row < groupNames.count + 1
            {
                groupNameCell = groupNames[indexPath.row]
                cell.userLabel.text = groupNameCell
                
            }
            return cell
            
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
        selectedRow = groupNames[indexPath.row]
        
        if indexPath.row < groupNames.count {
            print("groupInfo")
            
            self.performSegueWithIdentifier("groupInfoSegue", sender: nil)
            print(selectedRow)
            
        } else if (indexPath.row) == (groupNames.count) + 1 {
            print("groupCreate")
            self.performSegueWithIdentifier("groupCreateSegue", sender: nil)
            print(selectedRow)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "groupInfoSegue" {
            
            let dvc = segue.destinationViewController as! GroupInfoViewController
            
            dvc.itemId = selectedRow
            
            
        }
        
        if segue.identifier == "groupCreateSegue" {
            
        }
        
    }
    
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
}
