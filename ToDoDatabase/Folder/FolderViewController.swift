//
//  ViewController.swift
//  ToDoDatabase
//
//  Created by EvgeniiChistyakov on 02.04.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var model: Modeling!
    
    @IBOutlet private weak var tableview: UITableView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let database = DataBaseLayer()
        model = FolderModel(databaseService: database)
        model.setDelegate()
        model.setDelegateUI(view: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(moveToBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.fetchFolders()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let viewController = segue.destination as? TaskListViewController {
            if let folderObject = sender as? Folder {
                let database = DatabaseLayerTaskList()
                let model = ModelTaskList(databaseService: database, folderId: folderObject.objectID)
                viewController.model = model
            }
        }
    }
    
    @objc
    private func moveToBackground() {
        model.save()
    }
    
    private func updateUI() {
        let rightButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addFolderTap))
        navigationItem.rightBarButtonItem = rightButton
        title = "Folders"
        tableview.tableFooterView = UIView(frame: .zero)
    }
    
    @objc
    private func addFolderTap() {
        presentInputPopUp(isFolder: true) { [weak self] result in
            self?.model.addFolder(name: result.name)
        }
    }
}

// MARK: - DelegateUpdateUI

extension ViewController: DelegateUpdateUI {
    func insertRows(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableview.insertRows(at: [indexPath], with: .automatic)
    }
    
    func deleteRows(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableview.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func updateRows(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableview.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "folderCell")
        
        let currentFolder = model.fetchedObjects?[indexPath.row]
        cell.textLabel?.text = currentFolder?.name
        cell.detailTextLabel?.text = currentFolder?.date?.toString()
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if case .delete = editingStyle {
            model.deleteFolder(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showTaskList", sender: model.fetchedObjects?[indexPath.row])
    }
}
