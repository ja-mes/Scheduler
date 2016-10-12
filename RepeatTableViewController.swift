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

    
    // MARK: methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
    }
    
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        let oldCell = tableView.cellForRow(at: currentSelectedIndex)
        oldCell?.accessoryType = .none
        
        currentSelectedIndex = indexPath
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let cell = tableView.cellForRow(at: currentSelectedIndex)
        if let text = cell?.textLabel?.text {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "repeat_interval"), object: text)
        }
    }

    
    // MARK: IBActions
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }

}
