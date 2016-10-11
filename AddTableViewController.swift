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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.indexPath(for: entryDateCell) == indexPath {
            performSegue(withIdentifier: "EntryDateViewController", sender: nil)
        }
    }

}
