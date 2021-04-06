//
//  ModuleAssembler.swift
//  ToDoDatabase
//
//  Created by EvgeniiChistyakov on 06.04.2021.
//

import UIKit
import CoreData.NSManagedObjectID

protocol ModuleAssembling {
    func createFolderModule(coordinator: MainCoordinator) -> UIViewController
    func createTaskListModule(coordinator: MainCoordinator, objectId: NSManagedObjectID) -> UIViewController
    func createAlertModule(
        coordinator: MainCoordinator,
        isFolder: Bool,
        completion: @escaping (TaskData?) -> Void
    ) -> UIViewController
}

class ModuleAssembler: ModuleAssembling {
    func createFolderModule(coordinator: MainCoordinator) -> UIViewController {
        let rootViewController = FolderViewController.instantiateFromStoryboard()
        rootViewController.coordinator = coordinator
        coordinator.presenter = rootViewController
        
        let database = DataBaseLayer()
        let model = FolderModel(databaseService: database)
        model.setDelegate()
        model.setDelegateUI(view: rootViewController)
        rootViewController.model = model
        
        return rootViewController
    }
    
    func createTaskListModule(coordinator: MainCoordinator, objectId: NSManagedObjectID) -> UIViewController {
        let taskListViewController = TaskListViewController.instantiateFromStoryboard()
        taskListViewController.coordinator = coordinator
        coordinator.presenter = taskListViewController
        
        let database = DatabaseLayerTaskList()
        let model = ModelTaskList(databaseService: database, folderId: objectId)
        taskListViewController.model = model
        
        return taskListViewController
    }
    
    func createAlertModule(
        coordinator: MainCoordinator,
        isFolder: Bool,
        completion: @escaping (TaskData?) -> Void
    ) -> UIViewController {
        let alertVC = AlertViewController.instantiateFromStoryboard()
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .coverVertical
        
        alertVC.isFolder = isFolder
        alertVC.completion = completion
        
        return alertVC
    }
}
