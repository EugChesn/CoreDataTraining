//
//  AppDelegate.swift
//  ToDoDatabase
//
//  Created by EvgeniiChistyakov on 02.04.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate, BaseDataBase {
    
    var window: UIWindow?
    var coordinator: MainCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        checkFirstLaunch()
        configureRootCoordinator()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
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
    
    private func configureRootCoordinator() {
        let navController = UINavigationController()
        let moduleAssembler = ModuleAssembler()
        coordinator = MainCoordinator(navigationController: navController, moduleAssembler: moduleAssembler)
        coordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    private func checkFirstLaunch() {
        if UserDefaults.isFirstLaunch() {
            //Container + Context
            let viewContext = persistentContainer.viewContext
            
            //ManagedObjects
            let folder = Folder.createFolder(name: "Temp", date: Date(), context: viewContext)
            let task = Task.createTask(name: "First", content: "Start", date: Date(), context: viewContext)
            
            //Relation
            var setTasks = Set<Task>()
            setTasks.insert(task)
            folder.tasks = setTasks
        }
    }
}

