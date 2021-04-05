//
//  Model.swift
//  ToDoDatabase
//
//  Created by EvgeniiChistyakov on 02.04.2021.
//

import Foundation
import CoreData.NSFetchedResultsController

protocol DelegateUpdateUI: class {
   func insertRows(index: Int)
    
   func deleteRows(index: Int)
    
   func updateRows(index: Int)
}

protocol Modeling {
    func fetchFolders()
    func addFolder(name: String)
    func deleteFolder(index: Int)
    func save()
    
    func setDelegate()
    func setDelegateUI(view: DelegateUpdateUI?)
    
    var fetchedObjects: [Folder]? { get }
}

class FolderModel: NSObject {
    
    private var databaseService: DataBasing
    
    weak var delegateUpdateView: DelegateUpdateUI?
    
    init(databaseService: DataBasing) {
        self.databaseService = databaseService
    }
    
    func setDelegateUI(view: DelegateUpdateUI?) {
       delegateUpdateView = view
    }
    
    func setDelegate() {
        self.databaseService.setDelegate(delegate: self)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension FolderModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            delegateUpdateView?.insertRows(index: newIndexPath.row)
            
        case .delete:
            guard let indexPath = indexPath else { return }
            delegateUpdateView?.deleteRows(index: indexPath.row)
            
        case .update:
            guard let indexPath = indexPath else { return }
            delegateUpdateView?.updateRows(index: indexPath.row)
        default:
            break
        }
        
    }
}

// MARK: - Modeling

extension FolderModel: Modeling {
    func fetchFolders() {
        databaseService.fetchFolders()
    }
    
    func addFolder(name: String) {
        databaseService.addFolder(name: name)
    }
    
    func deleteFolder(index: Int) {
        databaseService.deleteFolder(index: index)
    }
    
    func save() {
        databaseService.saveContext()
    }
    
    var fetchedObjects: [Folder]? {
        databaseService.fetchedObjects
    }
}
