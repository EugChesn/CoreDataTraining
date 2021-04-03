//
//  Folder.swift
//  ToDoDatabase
//
//  Created by EvgeniiChistyakov on 02.04.2021.
//

import Foundation
import CoreData

class Folder: NSManagedObject {
    @discardableResult
    static func createFolder(name: String, date: Date, context: NSManagedObjectContext) -> Folder {
        let model = Folder(context: context)
        model.name = name
        model.date = date
        return model
    }
}

extension Folder {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var tasks: Set<Task>?
}

extension Folder : Identifiable {

}
