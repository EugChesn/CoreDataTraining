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
    func addTask(data: TaskData)
    func removeTask(index: Int)
    
    var taskList: [Task] { get }
    var folderName: String { get }
    var delegateView: DelegateUpdateViewTaskList? { get set }
}

class ModelTaskList: NSObject, TaskListModeling {
 
    private var databaseService: DatabaseLayerTaskList?
    private var folder: Folder
    
    weak var delegateView: DelegateUpdateViewTaskList?
    
    var folderName: String {
        folder.name ?? "ERROR"
    }
    
    var taskList: [Task] = [] {
        didSet {
            delegateView?.update()
        }
    }
    
    init(databaseService: DatabaseLayerTaskList, folder: Folder) {
        self.databaseService = databaseService
        self.folder = folder
        self.taskList = Array(folder.tasks ?? [])
    }
    
    func addTask(data: TaskData) {
        if let task = databaseService?.addTask(folder: folder, taskData: data) {
            taskList.append(task)
        }
    }
    
    func removeTask(index: Int) {
        let task = taskList.remove(at: index)
        databaseService?.removeTask(folder: folder, task: task)
    }
}
