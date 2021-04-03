//
//  DataBaseLayer.swift
//  ToDoDatabase
//
//  Created by EvgeniiChistyakov on 02.04.2021.
//

import Foundation
import CoreData

protocol DataBasing: class {
    func fetchFolders()
    func addFolder(name: String)
    func deleteFolder(index: Int)
    func setDelegate(delegate: NSFetchedResultsControllerDelegate)
    
    func addTask(taskData: TaskData, folderName: String) -> Task?
    
    var fetchedObjects: [Folder]? { get }
}

class DataBaseLayer {
    
    init() {
        viewContext.automaticallyMergesChangesFromParent = true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "modelData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var fetchedResultController: NSFetchedResultsController<Folder> = {
        let request: NSFetchRequest = Folder.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Folder.name), ascending: true)]

        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }

    func setDelegate(delegate: NSFetchedResultsControllerDelegate) {
        fetchedResultController.delegate = delegate
    }
    
    deinit {
        print("deinit database")
    }
}


extension DataBaseLayer: DataBasing {
    
    var fetchedObjects: [Folder]? { fetchedResultController.fetchedObjects }
    
    func fetchFolders() {
        try? fetchedResultController.performFetch()
    }
    
    func addFolder(name: String) {
        let background = backgroundContext
        background.performAndWait {
            Folder.createFolder(name: name, date: Date(), context: background)
            try? background.save()
        }
    }
    
    func deleteFolder(index: Int) {
        if let object = fetchedObjects?[index] {
            viewContext.delete(object)
            try? viewContext.save()
        }
    }
    
    func addTask(taskData: TaskData, folderName: String) -> Task? {
        let task = Task.createTask(name: taskData.name, content: taskData.content, date: Date(), context: viewContext)
        if let index = fetchedObjects?.firstIndex(where: { $0.name == folderName }) {
            fetchedObjects?[index].tasks?.insert(task)
            do {
                try viewContext.save()
            } catch {
                print("error save viewcontext")
            }
            return task
            
        } else {
            return nil
        }
    }
}
