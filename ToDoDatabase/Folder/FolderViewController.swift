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
    
    @IBOutlet private weak var addButton: UIButton!
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
        tableview.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.fetchFolders()
    }
    
    @IBAction private func addFolderTap() {
        presentInputPopUp(isFolder: true) { [weak self] result in
            self?.model.addFolder(name: result.name)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let viewController = segue.destination as? TaskListViewController {
            if let folderObject = sender as? Folder {
                let database = DatabaseLayerTaskList()
                let model = ModelTaskList(databaseService: database, folder: folderObject)
                viewController.model = model
            }
        }
    }
}

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

//UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "folderCell")
        cell.textLabel?.text = model.fetchedObjects?[indexPath.row].name
        cell.detailTextLabel?.text = model.fetchedObjects?[indexPath.row].date?.toString()
        
        return cell
    }
    
}

//UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableview.frame.width, height: 70))
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 24)
        label.text = "Folders"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }
    
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
