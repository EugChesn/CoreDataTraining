//
//  TaskListViewController.swift
//  ToDoDatabase
//
//  Created by EvgeniiChistyakov on 03.04.2021.
//

import UIKit

class TaskListViewController: UIViewController {
    
    var model: TaskListModeling!
    weak var coordinator: MainCoordinator?
    
    @IBOutlet private weak var tableView: UITableView!
    
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
        model.fetchFolderById()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.save()
    }
    
    @objc
    private func moveToBackground() {
        model.save()
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
        coordinator?.presentInputPopUp { [weak self] result in
            self?.coordinator?.dismissInputPopUp()
            guard let result = result else { return }
            self?.model.addTask(data: result)
        }
    }
}

extension TaskListViewController: DelegateUpdateViewTaskList {
    func update() {
        title = model.folderName
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
