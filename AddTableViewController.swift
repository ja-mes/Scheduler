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
    @IBOutlet weak var repeatCell: UITableViewCell!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var recipientField: UITextField!
    @IBOutlet weak var messageField: UITextView!
    
    var reminder: Reminder?
    var date = Date()
    var repeatInterval = REPEAT_INTERVALS[0]
    
    
    // MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        
        displayDate()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateEntryDate(notification:)), name: NSNotification.Name(rawValue: "entry_date"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateRepeatInterval(notification:)), name: Notification.Name(rawValue: "repeat_interval"), object: nil)
        
        if let reminder = reminder {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "repeat_interval"), object: reminder.repeatInterval)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "entry_date"), object: reminder.entryDate)
            
            descriptionField.text = reminder.name
            recipientField.text = reminder.recipient
            messageField.text = reminder.message
            
        }
    }
    
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.indexPath(for: entryDateCell) == indexPath {
            performSegue(withIdentifier: "EntryDateViewController", sender: nil)
        } else if tableView.indexPath(for: repeatCell) == indexPath {
            performSegue(withIdentifier: "RepeatViewController", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EntryDateViewController" {
            if let destination = segue.destination as? EntryDateViewController {
                destination.date = date
            }
        } else if segue.identifier == "RepeatViewController" {
            if let destination = segue.destination as? RepeatTableViewController {
                if let selectedInt = REPEAT_INTERVALS.index(of: repeatInterval) {
                    destination.currentSelectedIndex = IndexPath(row: selectedInt, section: 0)
                }
            }
        }
    }
    
    // MARK: IBActions
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        let item: Reminder!
        
        if reminder == nil {
            item = Reminder(context: context)
        } else {
            item = reminder
        }
        
        let validator = Validator()

        if let text = descriptionField.text, text.isEmpty == false, let recipient = recipientField.text, text.isEmpty == false, let message = messageField.text, message.isEmpty == false {
            if validator.validEmail(value: recipient) {
                print("valid email")
                item.type = "email"
            } else {
                item.type = "text"
            }
            
            item.entryDate = date
            item.repeatInterval = repeatInterval
            item.name = descriptionField.text
            item.recipient = recipientField.text
            item.message = messageField.text

            ad.saveContext()
        } else {
            if item.objectID.isTemporaryID {
                context.delete(item)
            }
            let alert = UIAlertController(title: "Oops!", message: "Please fill out all fields", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: func
    func updateEntryDate(notification: Notification) {
        if let date = notification.object as? Date {
            self.date = date
            displayDate()
        }
    }
    
    func updateRepeatInterval(notification: Notification) {
        if let text = notification.object as? String {
            self.repeatInterval = text
            repeatCell.textLabel?.text = text
        }
    }
    
    func displayDate() {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = .short
        
        entryDateCell.textLabel?.text = "\(formatter.string(from: date))"
    }

}
