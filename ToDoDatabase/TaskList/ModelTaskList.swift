//
//  ModelTaskList.swift
//  ToDoDatabase
//
//  Created by EvgeniiChistyakov on 03.04.2021.
//

import Foundation
import CoreData

protocol DelegateUpdateViewTaskList: class {
    func update()
}

protocol TaskListModeling {
    func fetchFolderById()
    func addTask(data: TaskData)
    func removeTask(index: Int)
    func save()
    
    var taskList: [Task] { get }
    var folderName: String? { get }
    var delegateView: DelegateUpdateViewTaskList? { get set }
}

class ModelTaskList {
 
    private var databaseService: DatabaseLayerTaskList
    private var folderId: NSManagedObjectID
    
    weak var delegateView: DelegateUpdateViewTaskList?
    
    var taskList: [Task] = [] {
        didSet {
            delegateView?.update()
        }
    }
        
    init(databaseService: DatabaseLayerTaskList, folderId: NSManagedObjectID) {
        self.databaseService = databaseService
        self.folderId = folderId
        self.databaseService.delegate = self
    }
}

// MARK: - DelegateHandleFetchFolder

extension ModelTaskList: DelegateHandleFetchFolder {
    func handleFetchedFodler() {
        taskList = Array(databaseService.fetchedFolder?.tasks ?? [])
    }
}

// MARK: - TaskListModeling

extension ModelTaskList: TaskListModeling {
    var folderName: String? {
        databaseService.fetchedFolder?.name
    }
    
    func save() {
        databaseService.saveContext()
    }
    
    func fetchFolderById() {
        databaseService.fetchFolder(folderId: folderId)
    }
    
    func addTask(data: TaskData) {
        let task = databaseService.addTask(taskData: data)
        taskList.append(task)
    }
    
    func removeTask(index: Int) {
        let task = taskList.remove(at: index)
        databaseService.removeTask(task: task)
    }
}
