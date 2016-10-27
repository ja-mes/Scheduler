//
//  Reminder+CoreDataClass.swift
//  Scheduler
//
//  Created by James Brown on 10/23/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit
import CoreData


public class Reminder: NSManagedObject {
    
    func save(_ viewController: UIViewController) {
        if id == nil {
            id = NSUUID().uuidString
        }
        
        do {
            type = try Validator().messageType(message: recipient)
        } catch ValidationError.Invalid {
            
        } catch {
            fatalError(error)
        }
        
        
        do {
            try validateForInsert()
        } catch {
            print(error)
        }
        
        let validationResult = validate()
        
        if validationResult == "success" {
            ad.saveContext()
            
            UserNotification().schedule(self)
        } else if validationResult == "incomplete" {
            if objectID.isTemporaryID {
                context.delete(self)
            }
            
            displayIncompleteAlert(viewController: viewController)
        }
        
    }
    
    
    func displayIncompleteAlert(viewController: UIViewController) {
        let alert = UIAlertController(title: "Oops!", message: "Please fill out recipient and message fields.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func validate() -> String {
        if
            let message = message, message.isEmpty == false,
            let recipient = recipient, recipient.isEmpty == false {
            return "success"
        } else {
            return "incomplete"
        }
    }
    
    func nextEntryDate() -> Date? {
        var nextEntryDate: Date?
        
        if let interval = repeatInterval, let entryDate = entryDate {
            switch interval {
            case REPEAT_INTERVALS[1]: // Daily
                nextEntryDate = NSCalendar.current.date(byAdding: .day, value: 1, to: entryDate)!
                break
            case REPEAT_INTERVALS[2]: // Weekly
                nextEntryDate = NSCalendar.current.date(byAdding: .day, value: 7, to: entryDate)!
                break
            case REPEAT_INTERVALS[3]: // Monthly
                nextEntryDate = NSCalendar.current.date(byAdding: .month, value: 1, to: entryDate)!
                break
            case REPEAT_INTERVALS[4]: // Yearly
                nextEntryDate = NSCalendar.current.date(byAdding: .year, value: 1, to: entryDate)!
                break
            default:
                nextEntryDate = nil
                break
            }
            
        }
        
        return nextEntryDate
    }
}







