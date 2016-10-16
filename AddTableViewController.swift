//
//  AddTableViewController.swift
//  Scheduler
//
//  Created by James Brown on 10/11/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class AddTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var recipientField: UITextField!
    @IBOutlet weak var messageField: UITextView!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var repeatField: UITextField!
    
    var reminder: Reminder?
    var date = Date()
    var repeatInterval = REPEAT_INTERVALS[0]
    
    
    // MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        if let reminder = reminder {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "repeat_interval"), object: reminder.repeatInterval)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "entry_date"), object: reminder.entryDate)
            
            recipientField.text = reminder.recipient
            messageField.text = reminder.message
            
        }
        
        
        // Repeat field
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        repeatField.inputView = picker
        repeatField.tintColor = UIColor.clear
        
        
        // Date field
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        dateField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        dateField.tintColor = UIColor.clear
        
    }
    
    // MARK: table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: picker view
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return REPEAT_INTERVALS[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let interval = REPEAT_INTERVALS[row]
        repeatField.text = interval
        
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

        if let recipient = recipientField.text, recipient.isEmpty == false, let message = messageField.text, message.isEmpty == false {
            if validator.validEmail(value: recipient) {
                print("valid email")
                item.type = "email"
            } else {
                item.type = "text"
            }
            
            item.entryDate = date
            item.repeatInterval = repeatInterval
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
    func displayDate() {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = .short
        
        //entryDateCell.textLabel?.text = "\(formatter.string(from: date))"
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateField.text = dateFormatter.string(from: sender.date)
    }

}
