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

class GroupUsersCollectionViewController: UICollectionViewController {
    
    
    var ref = FIRDatabase.database().reference()
    var usersDict = NSDictionary?()
    var user = FIRAuth.auth()?.currentUser
    var userNamesArray = [String]()
    var userImagesArray = [String]()
    var groupNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        ref.child("user_profile").child(user!.uid).child("groups").observeEventType(.Value, withBlock: {
            snapshot in
           
            for group in snapshot.children {
                self.groupNames.append(group.key)
            }
            print(self.groupNames)
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
        return self.groupNames.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as!
        GUserCollectionViewCell
        
        
       cell.userLabel.text = groupNames[indexPath.row]
        
        // Configure the cell
        
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
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
