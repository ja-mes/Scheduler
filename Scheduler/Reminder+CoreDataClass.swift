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
        
        if let recipient = recipient {
            if type == "text" {
                do {
                    try Validator().validPhone(value: recipient)
                } catch ValidationError.InvalidPhone {
                    displayAlert(viewController: viewController, title: "Invalid Phone Number", message: "Please enter a valid phone number")
                }
                catch {
                    fatalError("Phone validation failed")
                }
            } else if type == "email" {
                do {
                    try Validator().validEmail(value: recipient)
                } catch ValidationError.InvalidEmail {
                    displayAlert(viewController: viewController, title: "Invalid Email Address", message: "Please enter a valid email address")
                } catch {
                    fatalError("Email validation failed")
                }
            } else {
                fatalError("Message assigned invalid type")
            }
        }
        
        
        if validateContentExists() {
            ad.saveContext()
            
            UserNotification().schedule(self)
        } else {
            if objectID.isTemporaryID {
                context.delete(self)
            }
            
            displayAlert(viewController: viewController, title: "Oops", message: "Please fill out recipient and message fields")
        }
        
    }
    
    func displayAlert(viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func validateContentExists() -> Bool {
        if
            let message = message, message.isEmpty == false,
            let recipient = recipient, recipient.isEmpty == false {
            return true
        } else {
            return false
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







