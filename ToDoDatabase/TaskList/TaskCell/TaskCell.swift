//
//  TaskCell.swift
//  ToDoDatabase
//
//  Created by EvgeniiChistyakov on 04.04.2021.
//

import UIKit

class TaskCell: UITableViewCell {
    
    static let reuseIndetifier = "TaskCell"
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        timeLabel.font = .systemFont(ofSize: 12)
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        contentLabel.text = nil
        timeLabel.text = nil
    }

    func configure(name: String?, content: String?, date: Date?) {
        nameLabel.text = name
        contentLabel.text = content
        timeLabel.text = date?.toString()
    }
}
