//
//  Reminder+CoreDataClass.swift
//  Scheduler
//
//  Created by James Brown on 10/23/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import Foundation
import CoreData


public class Reminder: NSManagedObject {
    
    func save() {
        type = Validator().messageType(message: recipient)
        
        ad.saveContext()
    }
}
