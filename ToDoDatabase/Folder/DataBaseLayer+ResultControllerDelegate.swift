//
//  DataBaseLayer.swift
//  ToDoDatabase
//
//  Created by EvgeniiChistyakov on 02.04.2021.
//

import Foundation
import CoreData
import UIKit.UIApplication

protocol BaseDataBase: class {
    func saveContext(errorMessage: String?)
}

extension BaseDataBase {
    func saveContext(errorMessage: String? = nil) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        do {
            if viewContext.hasChanges {
                try viewContext.save()
            }
        } catch {
            fatalError("save context")
        }
    }
}

protocol DataBasing: BaseDataBase {
    func fetchFolders()
    func addFolder(name: String)
    func deleteFolder(index: Int)
    func setDelegate(delegate: NSFetchedResultsControllerDelegate)
    
    var fetchedObjects: [Folder]? { get }
}

class DataBaseLayer {
    
    private var persistentContainer: NSPersistentContainer {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer
    }
    
    private lazy var fetchedResultController: NSFetchedResultsController<Folder> = {
        let request: NSFetchRequest = Folder.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Folder.name), ascending: true)]

        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func setDelegate(delegate: NSFetchedResultsControllerDelegate) {
        fetchedResultController.delegate = delegate
    }
}

extension DataBaseLayer: DataBasing {
    
    var fetchedObjects: [Folder]? { fetchedResultController.fetchedObjects }
    
    func fetchFolders() {
        try? fetchedResultController.performFetch()
    }
    
    func addFolder(name: String) {
        Folder.createFolder(name: name, date: Date(), context: viewContext)
    }
    
    func deleteFolder(index: Int) {
        if let object = fetchedObjects?[index] {
            viewContext.delete(object)
        }
    }
}
