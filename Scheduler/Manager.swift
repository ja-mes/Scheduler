//
//  Manager.swift
//  Scheduler
//
//  Created by James Brown on 10/26/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import Foundation

class Manager {
    var _reminder: Reminder?
    
    var reminder: Reminder? {
        return _reminder
    }
    
    init(reminder: Reminder?) {
        _reminder = reminder
    }
    
    func save() {
        let item: Reminder!
        
        if let reminder = reminder {
            item = reminder
        } else {
            item = Reminder(context: context)
            item.id = NSUUID().uuidString
        }
        
        let validator = Validator()
        
        if isReminderValid() {
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
        }
    }
    
    func isReminderValid() -> Bool {
        if  let recipient = reminder?.recipient, recipient.isEmpty == false,
            let message = reminder?.message, message.isEmpty == false {
            return true
        }
        
        return false
    }
    
}
