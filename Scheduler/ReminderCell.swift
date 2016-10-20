//
//  ReminderCell.swift
//  Scheduler
//
//  Created by James Brown on 10/12/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var recipientLbl: UILabel!
    @IBOutlet weak var pastDue: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
}
