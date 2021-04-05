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
    func testMax(folder: Folder)
}

class DatabaseLayerTaskList: DataBaseTaskList {
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "modelData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private var backgroundContext: NSManagedObjectContext {
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
    
    func testMax(folder: Folder) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        request.resultType = .dictionaryResultType

        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "max"
        expressionDescription.expression = NSExpression(format: "date.@max")
        expressionDescription.expressionResultType = .dateAttributeType

        request.propertiesToFetch = [expressionDescription]
       
        
        persistentContainer.performBackgroundTask { (context) in
            do {
                if let result = try context.fetch(request) as? [[String: Date]] {
                    print(result.first?.values)
                }
            }
            catch {
                print("error")
            }
        }
    }
}
