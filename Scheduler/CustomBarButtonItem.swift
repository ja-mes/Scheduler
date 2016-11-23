//
//  CustomBarButtonItem.swift
//  Scheduler
//
//  Created by James Brown on 11/22/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

@IBDesignable
class CustomBarButtonItem: UIBarButtonItem {
    @IBInspectable var isBold: Bool = false {
        didSet {
            var font: UIFont?
            
            if isBold {
                font = UIFont(name: "AvenirNext-Medium", size: 18)
            } else {
                font = UIFont(name: "Avenir Next", size: 18)
            }
            
            if let font = font {
                self.setTitleTextAttributes([NSFontAttributeName : font], for: UIControlState.normal)
                self.setTitleTextAttributes([NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.gray], for: UIControlState.disabled)
            }
        }
    }
}
