//
//  Reminder+CoreDataProperties.swift
//  Scheduler
//
//  Created by James Brown on 10/23/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder");
    }

    @NSManaged public var entryDate: Date?
    @NSManaged public var message: String?
    @NSManaged public var recipient: String?
    @NSManaged public var repeatInterval: String?
    @NSManaged public var type: String?
    @NSManaged public var subject: String?
    @NSManaged public var id: String?
    @NSManaged public var sent: Bool

}
