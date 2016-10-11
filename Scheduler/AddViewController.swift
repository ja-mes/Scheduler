//
//  AddViewController.swift
//  Scheduler
//
//  Created by James Brown on 10/11/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: IBActions
    
    @IBAction func cancelPressed(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }

}
