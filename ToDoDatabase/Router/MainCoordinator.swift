//
//  MainCoordinator.swift
//  ToDoDatabase
//
//  Created by EvgeniiChistyakov on 06.04.2021.
//

import UIKit
import CoreData.NSManagedObjectID

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

protocol MainRouting {
    func showTaskList(objectId: NSManagedObjectID)
    func presentInputPopUp(
        isFolder: Bool,
        completion: @escaping (TaskData?) -> Void
    )
    func dismissInputPopUp()
}

extension MainRouting {
    func presentInputPopUp(
        isFolder: Bool,
        completion: @escaping (TaskData?) -> Void
    ) {
        presentInputPopUp(isFolder: false, completion: completion)
    }
}

class MainCoordinator: Coordinator, MainRouting {
    var childCoordinators = [Coordinator]()
    
    var moduleAssembler: ModuleAssembling
    var navigationController: UINavigationController
    weak var presenter: UIViewController?

    init(navigationController: UINavigationController, moduleAssembler: ModuleAssembling) {
        self.navigationController = navigationController
        self.moduleAssembler = moduleAssembler
    }

    func start() {
        let rootViewController = moduleAssembler.createFolderModule(coordinator: self)
        navigationController.pushViewController(rootViewController, animated: false)
    }
    
    func showTaskList(objectId: NSManagedObjectID) {
        let taskListViewController = moduleAssembler.createTaskListModule(coordinator: self, objectId: objectId)
        navigationController.pushViewController(taskListViewController, animated: true)
    }
    
    func presentInputPopUp(
        isFolder: Bool = false,
        completion: @escaping (TaskData?) -> Void
    ) {
        let alertVC = moduleAssembler.createAlertModule(coordinator: self, isFolder: isFolder, completion: completion)
        presenter?.view.alpha = 0.4
        presenter?.present(alertVC, animated: true)
    }
    
    func dismissInputPopUp() {
        UIView.animate(withDuration: 0.4) {
            self.presenter?.view.alpha = 1
        }
        presenter?.dismiss(animated: true)
    }
}
