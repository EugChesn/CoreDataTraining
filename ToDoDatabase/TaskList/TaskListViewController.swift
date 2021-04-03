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
    @IBOutlet private weak var buttonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegateView = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")

        buttonView.layer.cornerRadius = buttonView.frame.width / 2
        buttonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPlus)))
    }
    
    @objc
    func tapPlus() {
        presentInputPopUp { [weak self] result in
            self?.model.addTask(data: result)
        }
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TaskCell")
        
        cell.textLabel?.text = model.taskList[indexPath.row].name
        cell.detailTextLabel?.text = model.taskList[indexPath.row].content
        
        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 70))
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 24)
        label.text = model.folderName
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
            model.removeTask(index: indexPath.row)
        }
    }
}
