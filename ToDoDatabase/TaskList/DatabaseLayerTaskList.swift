//
//  DatabaseTaskList.swift
//  ToDoDatabase
//
//  Created by EvgeniiChistyakov on 04.04.2021.
//

import Foundation
import CoreData
import UIKit.UIApplication


protocol DataBaseTaskList: BaseDataBase {
    var fetchedFolder: Folder? { get }
    var delegate: DelegateHandleFetchFolder? { get set }
    
    func fetchFolder(folderId: NSManagedObjectID)
    func addTask(taskData: TaskData) -> Task
    func removeTask(task: Task)
}

protocol DelegateHandleFetchFolder: class {
    func handleFetchedFodler()
}

class DatabaseLayerTaskList: DataBaseTaskList {
        
    private var persistentContainer: NSPersistentContainer {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer
    }
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    weak var delegate: DelegateHandleFetchFolder?
    
    private(set) var fetchedFolder: Folder? {
        didSet {
            delegate?.handleFetchedFodler()
        }
    }
    
    func fetchFolder(folderId: NSManagedObjectID) {
        fetchedFolder = persistentContainer.viewContext.object(with: folderId) as? Folder
    }
        
    func addTask(taskData: TaskData) -> Task {
        let task = Task.createTask(name: taskData.name, content: taskData.content, date: Date(), context: viewContext)
        task.folder = fetchedFolder
        fetchedFolder?.tasks?.insert(task)
        return task
    }
    
    func removeTask(task: Task) {
        fetchedFolder?.tasks?.remove(task)
    }
}

// MARK: Example using agregate functions

extension DatabaseLayerTaskList {
    func testMax(folder: Folder) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        request.resultType = .dictionaryResultType

        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "max"
        expressionDescription.expression = NSExpression(format: "date.@max")
        expressionDescription.expressionResultType = .dateAttributeType

        request.propertiesToFetch = [expressionDescription]
       
        
//        persistentContainer.performBackgroundTask { (context) in
//            do {
//                if let result = try context.fetch(request) as? [[String: Date]] {
//                    print(result.first?.values)
//                }
//            }
//            catch {
//                print("error")
//            }
//        }
    }
}
