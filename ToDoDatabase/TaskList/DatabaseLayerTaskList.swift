//
//  DatabaseTaskList.swift
//  ToDoDatabase
//
//  Created by EvgeniiChistyakov on 04.04.2021.
//

import Foundation
import CoreData

protocol DataBaseTaskList {
    func addTask(folder: Folder, taskData: TaskData) -> Task?
    func removeTask(folder: Folder, task: Task)
}

class DatabaseLayerTaskList: DataBaseTaskList {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "modelData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
        
    func addTask(folder: Folder, taskData: TaskData) -> Task? {
        if let context = folder.managedObjectContext {
            let task = Task.createTask(name: taskData.name, content: taskData.content, date: Date(), context: context)
            folder.tasks?.insert(task)
            do {
                try context.save()
                return task
            } catch {
                return nil
            }
        }
        
        return nil
    }
    
    func removeTask(folder: Folder, task: Task) {
        if let context = folder.managedObjectContext {
            folder.tasks?.remove(task)
            do {
                try context.save()
            } catch {
                print("error")
            }
        }
    }
}
