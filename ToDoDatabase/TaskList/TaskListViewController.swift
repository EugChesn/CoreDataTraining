//
//  TaskListViewController.swift
//  ToDoDatabase
//
//  Created by EvgeniiChistyakov on 03.04.2021.
//

import UIKit

class TaskListViewController: UIViewController {
    
    var model: TaskListModeling!
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        title = model.folderName
        let rightButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(tapPlus))
        navigationItem.rightBarButtonItem = rightButton
        
        model.delegateView = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: TaskCell.reuseIndetifier, bundle: nil ), forCellReuseIdentifier: TaskCell.reuseIndetifier)
    }
    
    @objc
    func tapPlus() {
        presentInputPopUp { [weak self] result in
            self?.model.addTask(data: result)
        }
       // model.testMax()
    }
}

extension TaskListViewController: DelegateUpdateViewTaskList {
    func update() {
        tableView.reloadData()
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseIndetifier, for: indexPath) as? TaskCell
        else { return .init() }
        
        let task = model.taskList[indexPath.row]
        cell.configure(name: task.name, content: task.content, date: task.date)
        
        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if case .delete = editingStyle {
            model.removeTask(index: indexPath.row)
        }
    }
}
