//
//  Item+CoreDataClass.swift
//  CoreData-to-do-list
//
//  Created by Dmitrii Nazarov on 05.11.2024.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {

}
extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var text: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var folder: Folder?

}

extension Item : Identifiable {

}
