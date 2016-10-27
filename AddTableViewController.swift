//
//  AddTableViewController.swift
//  Scheduler
//
//  Created by James Brown on 10/11/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit
import UserNotifications
import MessageUI
import ContactsUI
import PhoneNumberKit

class AddTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, CNContactPickerDelegate {

    // MARK: properties
    
    // outlets
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var messageField: UITextView!
    @IBOutlet weak var subjectField: UITextField!

    @IBOutlet weak var recipientCell: UITableViewCell!
    @IBOutlet weak var recipientField: UITextField!
    
    @IBOutlet weak var dateCell: UITableViewCell!
    @IBOutlet weak var dateField: UITextField!
    
    @IBOutlet weak var repeatCell: UITableViewCell!
    @IBOutlet weak var repeatField: UITextField!
    
    // global vars
    var reminder: Reminder?
    var isEmail = false
    
    var date = Date()
    var repeatInterval = REPEAT_INTERVALS[0]
    var canSave = false
    
    // pickers
    var picker: UIPickerView!
    var datePicker: UIDatePicker!
    
    
    // MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        }
        
        // Message field
        messageField.delegate = self
        
        // Repeat field
        picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        repeatField.inputView = picker
        repeatField.tintColor = UIColor.clear
        
        
        // Date field
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        dateField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        dateField.tintColor = UIColor.clear
        
        
        // Inital data
        if let reminder = reminder {
            saveButton.isEnabled = true
            
            recipientField.text = reminder.recipient
            subjectField.text = reminder.subject
            messageField.text = reminder.message
            
            if reminder.type == "email" {
                subjectField.text = reminder.subject
            }

            
            if let entryDate = reminder.entryDate {
                date = entryDate
                
                datePicker.setDate(date, animated: true)
                displayDate(date: date)
            }
            
            if let interval = reminder.repeatInterval {
                repeatInterval = interval
                repeatField.text = reminder.repeatInterval
                
                if let index = REPEAT_INTERVALS.index(of: interval) {
                    picker.selectRow(index, inComponent: 0, animated: true)
                }
            }

        } else {
            displayDate(date: date)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let reminder = reminder {
            if let entryDate = reminder.entryDate {
                setDateTextColor(date: entryDate)
            }
        } else {
            recipientField.becomeFirstResponder()
        }
    }
    
    // MARK: table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        resetFields()
        
        if tableView.indexPath(for: dateCell) == indexPath {
            dateField.isUserInteractionEnabled = true
            dateField.becomeFirstResponder()
            
            dateField.textColor = navigationController?.navigationBar.tintColor
        } else if tableView.indexPath(for: repeatCell) == indexPath {
            repeatField.isUserInteractionEnabled = true
            repeatField.becomeFirstResponder()
            
            repeatField.textColor = navigationController?.navigationBar.tintColor
        } else if tableView.indexPath(for: recipientCell) == indexPath {
            recipientField.becomeFirstResponder()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == IndexPath(row: 2, section: 1) && !isEmail {
            return 0.0
        } else if indexPath == IndexPath(row: 0, section: 2) {
            return 280.0
        }
        
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && reminder == nil {
            return 0
        }
        else if section == 0 && reminder?.sent == true {
            return 2
        }
        else if section == 0 {
            return 1
        }
        else if section == 1 {
            return 4
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && reminder == nil {
            return 0.1
        } else if section == 2 {
            return 44
        }
    
        return 0
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
        repeatInterval = interval
    }
    
    
    // MARK: text view
    func textViewDidBeginEditing(_ textView: UITextView) {
        resetFields()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        shouldEnableSave()
    }
    
    // MARK: messages
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        if result == .sent {
            rescheduleMessage()
            
            dismiss(animated: true, completion: nil)
            _ = navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .sent {
            rescheduleMessage()
            
            dismiss(animated: true, completion: nil)
            _ = navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: contact picker

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        if contactProperty.key == "phoneNumbers", let value = contactProperty.value as? CNPhoneNumber {
           recipientField.text = value.stringValue
            
        } else if contactProperty.key == "emailAddresses", let value = contactProperty.value as? String {
            recipientField.text = value
            
        }
        
        shouldEnableSave()
    }
    
    
    // MARK: IBAction
    @IBAction func editingBegan(_ sender: AnyObject) {
        resetFields()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendNowPressed(_ sender: UIButton) {
       sendMessage()
    }
    
    @IBAction func reschedulePressed(_ sender: UIButton) {
        save(reminder: nil)
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        save(reminder: reminder)
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addContactPressed(_ sender: UIButton) {
        let contactsPicker = CNContactPickerViewController()
        
        contactsPicker.delegate = self
        contactsPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
        
        present(contactsPicker, animated: true, completion: nil)
    }
    
    
    // MARK: func
    func save(reminder: Reminder?) {
        let item: Reminder!
        
        if let reminder = reminder {
            item = reminder
        } else {
            item = Reminder(context: context)
        }
        
        item.entryDate = date
        item.repeatInterval = repeatInterval
        item.recipient = recipientField.text
        item.message = messageField.text
        
        item.save(self)
        
    }
    
    func sendMessage() {
        if let reminder = reminder {
            save(reminder: reminder)
            
            if let message = reminder.message, let recipient = reminder.recipient {
                if reminder.type == "text", MFMessageComposeViewController.canSendText() {
                    let messageController = MFMessageComposeViewController()
                    messageController.body = message
                    messageController.recipients = [recipient]
                    messageController.messageComposeDelegate = self
                    
                    present(messageController, animated: true, completion: nil)
                } else if reminder.type == "email", MFMailComposeViewController.canSendMail() {
                    let mailController = MFMailComposeViewController()
                    mailController.mailComposeDelegate = self
                    
                    mailController.setToRecipients([recipient])
                    mailController.setMessageBody(message, isHTML: false)
                    
                    if let subject = reminder.subject {
                        mailController.setSubject(subject)
                    }
                    
                    present(mailController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func rescheduleMessage() {
        if let reminder = reminder {
            reminder.sent = true
            ad.saveContext()
            
            if let nextEntryDate = reminder.nextEntryDate() {
                date = nextEntryDate
                save(reminder: nil)
            }
            
        }
    }
    
    func shouldEnableSave() {
        if recipientField.text?.isEmpty != true, messageField.text.isEmpty != true {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    func handleDatePicker(sender: UIDatePicker) {
            date = sender.date.truncateSeconds()
            displayDate(date: date)
    }
    
    func displayDate(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateField.text = dateFormatter.string(from: date)
    }
    
    func resetFields() {
        repeatField.isUserInteractionEnabled = false
        dateField.isUserInteractionEnabled = false
        
        repeatField.textColor = UIColor.black
        dateField.textColor = UIColor.black
        
        if let date = reminder?.entryDate {
            setDateTextColor(date: date)
        }
    }
    
    func setDateTextColor(date: Date) {
        if Date().compare(date) == ComparisonResult.orderedDescending && reminder?.sent == false {
            dateField.textColor = UIColor.red
        } else {
            dateField.textColor = UIColor.black
        }
        
    }
    
}
