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
    
    var date = Date()
    var repeatInterval = REPEAT_INTERVALS[0]
    
    
    // MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        
        displayDate()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateEntryDate(notification:)), name: NSNotification.Name(rawValue: "entry_date"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateRepeatInterval(notification:)), name: Notification.Name(rawValue: "repeat_interval"), object: nil)
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
        let item = Reminder(context: context)
        
        item.entryDate = date
        item.repeatInterval = repeatInterval
        item.name = descriptionField.text
        item.recipient = recipientField.text
        item.message = messageField.text
        
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: func
    func isValidEmail(string :String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: string)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
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
