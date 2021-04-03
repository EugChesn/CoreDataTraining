//
//  Task.swift
//  ToDoDatabase
//
//  Created by EvgeniiChistyakov on 02.04.2021.
//

import Foundation
import CoreData

class Task: NSManagedObject {
    static func createTask(name: String, content: String, date: Date, context: NSManagedObjectContext) -> Task {
        let model = Task(context: context)
        model.name = name
        model.date = date
        model.content = content
        return model
    }
}

extension Task {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var content: String?
    @NSManaged public var folder: Folder?
}

extension Task : Identifiable {

}
