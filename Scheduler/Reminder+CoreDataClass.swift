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
        
        type = Validator().messageType(message: recipient)
        
        if isValid() {
            ad.saveContext()
        } else {
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
    
    func isValid() -> Bool {
        if
            let message = message, message.isEmpty == false,
            let recipient = recipient, recipient.isEmpty == false {
            return true
        }
        
        return false
    }
}
