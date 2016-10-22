//
//  GUserCollectionViewCell.swift
//  musifinder
//
//  Created by Paul Beneteau on 11/10/2016.
//  Copyright © 2016 tastyapp. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class GUserCollectionViewCell: UICollectionViewCell {
    
    var ref = FIRDatabase.database().reference()
    var membersCount: Int!

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userCount: UILabel!
 
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let groupName = userLabel.text
        
        ref.child("user_groups").child(groupName!).child("members").observeEventType(.Value, withBlock: {
            snapshot in
            
           self.membersCount = snapshot.value!.count
           self.userCount?.text = "\(self.membersCount)"
            
        })
        

      
    }
    
    
}
