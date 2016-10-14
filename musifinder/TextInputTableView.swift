//
//  TextInputTableView.swift
//  musifinder
//
//  Created by Paul Beneteau on 05/10/2016.
//  Copyright © 2016 TastyApptastyapp. All rights reserved.
//

import UIKit

public class TextInputTableView: UITableViewCell {
    
   @IBOutlet weak var myTextField: UITextField!
    
    
    
    public func configure(text:String?, placeholder:String?){
        myTextField.text = text
        myTextField.placeholder = placeholder
    }

}
