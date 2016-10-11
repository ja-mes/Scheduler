//
//  AddTableViewController.swift
//  Scheduler
//
//  Created by James Brown on 10/11/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class AddTableViewController: UITableViewController {

    @IBOutlet weak var entryDateCell: UITableViewCell!
    
    var date: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        
        date = Date()
        
        entryDateCell.textLabel?.text = "\(date!)"
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateEntryDate(notification:)), name: NSNotification.Name(rawValue: "entry_date"), object: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.indexPath(for: entryDateCell) == indexPath {
            performSegue(withIdentifier: "EntryDateViewController", sender: nil)
        }
    }
    
    func updateEntryDate(notification: Notification) {
        if let date = notification.object as? Date {
            self.date = date
            entryDateCell.textLabel?.text = "\(date)"
        }
    }

}
