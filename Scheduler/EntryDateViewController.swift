//
//  EntryDateViewController.swift
//  Scheduler
//
//  Created by James Brown on 10/11/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class EntryDateViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    var date = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        datePicker.date = date
    }
    
    @IBAction func donePressed(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "entry_date"), object: datePicker.date)
    }
}
