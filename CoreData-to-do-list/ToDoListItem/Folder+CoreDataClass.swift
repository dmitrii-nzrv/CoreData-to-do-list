//
//  Folder+CoreDataClass.swift
//  CoreData-to-do-list
//
//  Created by Dmitrii Nazarov on 05.11.2024.
//
//

import Foundation
import CoreData

@objc(Folder)
public class Folder: NSManagedObject {

}
extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension Folder {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension Folder : Identifiable {

}
