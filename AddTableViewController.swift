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
    var date = Date()
    var repeatInterval = REPEAT_INTERVALS[0]
    var isValidEmail = false
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
                isValidEmail = true
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
        if indexPath == IndexPath(row: 2, section: 1) && !isValidEmail {
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
            
            
            isValidEmail = true
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        shouldEnableSave()
    }
    
    
    // MARK: IBAction
    @IBAction func editingBegan(_ sender: AnyObject) {
        resetFields()
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        shouldEnableSave()
        
        let validator = Validator()
        
        if let text = sender.text {
            var last = ""
            
            if let lastChar = text.characters.last {
                last = "\(lastChar)"
            }
            
            if validator.validEmail(value: text) {
                if !isValidEmail {
                    isValidEmail = true
                    tableView.beginUpdates()
                    tableView.endUpdates()
                    recipientField.becomeFirstResponder()
                }
                
                isValidEmail = true
            } else if last != "." {
                isValidEmail = false
                tableView.beginUpdates()
                tableView.endUpdates()
                recipientField.becomeFirstResponder()
            }
            
        }
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
        accessContacts()
        
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
            item.id = NSUUID().uuidString
        }
        
        let validator = Validator()
        
        if let recipient = recipientField.text, recipient.isEmpty == false, let message = messageField.text, message.isEmpty == false {
            if validator.validEmail(value: recipient) {
                item.type = "email"
                
                if subjectField.text?.isEmpty == false {
                    item.subject = subjectField.text
                }
            } else {
                item.type = "text"
            }
            
            item.entryDate = date
            item.repeatInterval = repeatInterval
            item.recipient = recipientField.text
            item.message = messageField.text
            
            
            ad.saveContext()
            
            
            scheduleNotification(reminder: item)
        } else {
            if item.objectID.isTemporaryID {
                context.delete(item)
            }
            let alert = UIAlertController(title: "Oops!", message: "Please fill out recipient and message fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func scheduleNotification(reminder: Reminder) {
        let content = UNMutableNotificationContent()
        
        if let entryDate = reminder.entryDate, let type = reminder.type, let id = reminder.id, let recipient = reminder.recipient {
            content.title = "\(type.capitalized) due"
            content.body = "Send your \(type) to \(recipient)"
            content.categoryIdentifier = "message"
            content.sound = UNNotificationSound.default()
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(in: .current, from: entryDate)
            let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if error != nil {
                    print("Error scheduling notification: \(error)")
                }
            })
            
        }
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
            
            if let interval = reminder.repeatInterval, let entryDate = reminder.entryDate {
                switch interval {
                case REPEAT_INTERVALS[1]: // Daily
                    date = NSCalendar.current.date(byAdding: .day, value: 1, to: entryDate)!
                    break
                case REPEAT_INTERVALS[2]: // Weekly
                    date = NSCalendar.current.date(byAdding: .day, value: 7, to: entryDate)!
                    break
                case REPEAT_INTERVALS[3]: // Monthly
                    date = NSCalendar.current.date(byAdding: .month, value: 1, to: entryDate)!
                    break
                case REPEAT_INTERVALS[4]: // Yearly
                    date = NSCalendar.current.date(byAdding: .year, value: 1, to: entryDate)!
                    break
                default:
                    date = entryDate
                    break
                }
                
                if interval != REPEAT_INTERVALS[0] {
                    save(reminder: nil)
                }
            }
            
        }
    }
    
    func accessContacts() {
        let contactStore = CNContactStore()
        
        contactStore.requestAccess(for: .contacts) { (access, error) in
            if access {
                // access has been granted
            } else {
                
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
