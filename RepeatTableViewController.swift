//
//  RepeatTableViewController.swift
//  Scheduler
//
//  Created by James Brown on 10/11/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class RepeatTableViewController: UITableViewController {
    
    var currentSelectedIndex = IndexPath(row: 0, section: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        let oldCell = tableView.cellForRow(at: currentSelectedIndex)
        oldCell?.accessoryType = .none
        
        currentSelectedIndex = indexPath
    }

}
