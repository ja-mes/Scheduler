//
//  RoundedButton.swift
//  Scheduler
//
//  Created by James Brown on 11/23/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    
    override func awakeFromNib() {
        layer.cornerRadius = frame.size.height / 2
    }

}
