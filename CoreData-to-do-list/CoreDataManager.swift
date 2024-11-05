//
//  CoreDataManager.swift
//  CoreData-to-do-list
//
//  Created by Dmitrii Nazarov on 04.11.2024.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData_to_do_list") // Название должно совпадать с именем .xcdatamodeld файла
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Ошибка загрузки Core Data: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Ошибка сохранения Core Data: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
