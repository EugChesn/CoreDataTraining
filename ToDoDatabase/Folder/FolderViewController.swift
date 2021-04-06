//
//  ViewController.swift
//  ToDoDatabase
//
//  Created by EvgeniiChistyakov on 02.04.2021.
//

import UIKit
import CoreData

class FolderViewController: UIViewController {
    
    var model: Modeling!
    weak var coordinator: MainCoordinator?
    
    @IBOutlet private weak var tableview: UITableView!
    
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
        coordinator?.presenter = self
        model.fetchFolders()
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
        coordinator?.presentInputPopUp(isFolder: true, completion: { [weak self] result in
            self?.coordinator?.dismissInputPopUp()
            guard let result = result else { return }
            self?.model.addFolder(name: result.name)
        })
    }
}

// MARK: - DelegateUpdateUI

extension FolderViewController: DelegateUpdateUI {
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

extension FolderViewController: UITableViewDataSource {
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

extension FolderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if case .delete = editingStyle {
            model.deleteFolder(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        
        if let id = model.fetchedObjects?[indexPath.row].objectID {
            coordinator?.showTaskList(objectId: id)
        }
    }
}
