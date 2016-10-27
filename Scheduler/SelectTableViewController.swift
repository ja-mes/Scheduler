//
//  SelectTableViewController.swift
//  Scheduler
//
//  Created by James Brown on 10/27/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class SelectTableViewController: UITableViewController {
    
    @IBOutlet weak var textMsgCell: UITableViewCell!
    @IBOutlet weak var emailCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.indexPath(for: textMsgCell) == indexPath {
            performSegue(withIdentifier: "CreateReminder", sender: false)
        } else if tableView.indexPath(for: emailCell) == indexPath {
            performSegue(withIdentifier: "CreateReminder", sender: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateReminder" {
            if let destination = segue.destination as? AddTableViewController {
                if let sender = sender as? Bool {
                    destination.isEmail = sender
                }
            }
        }
    }
}
