//
//  Notification.swift
//  
//
//  Created by James Brown on 10/26/16.
//
//

import UIKit
import UserNotifications

class UserNotification {
    func schedule(_ reminder: Reminder) {
        let action = UNNotificationAction(identifier: "sendNow", title: "Send Now", options: [])
        let category = UNNotificationCategory(identifier: "sendCategory", actions: [action], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().delegate = ad
        
        let content = UNMutableNotificationContent()
        
        if let entryDate = reminder.entryDate, let type = reminder.type, let id = reminder.id, let recipient = reminder.recipient {
            content.title = "\(type.capitalized) due:"
            content.body = "Send your \(type) to \(recipient)"
            content.categoryIdentifier = "message"
            content.sound = UNNotificationSound.default()
            content.categoryIdentifier = "sendCategory"
            
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
}
