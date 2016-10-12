//
//  Reminder+CoreDataProperties.swift
//  Scheduler
//
//  Created by James Brown on 10/12/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder");
    }

    @NSManaged public var name: String?
    @NSManaged public var entryDate: NSDate?
    @NSManaged public var repeatInterval: String?
    @NSManaged public var message: String?
    @NSManaged public var recipient: String?
    @NSManaged public var type: String?

}
