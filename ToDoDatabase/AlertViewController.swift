//
//  AlertViewController.swift
//  ToDoDatabase
//
//  Created by EvgeniiChistyakov on 03.04.2021.
//

import UIKit

struct TaskData {
    let name: String
    let content: String
    var folder: String?
}

class AlertViewController: UIViewController {
    
    @IBOutlet private weak var labelAlert: UILabel! {
        didSet {
            labelAlert.text = isFolder ? "Create Folder" : "Create Task"
        }
    }
    @IBOutlet private weak var contentTextfield: UITextField! {
        didSet {
            contentTextfield.isHidden = isFolder
        }
    }
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var sheetView: UIView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    var completion: ((TaskData?) -> (Void))?
    var isFolder: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        swipeGesture.direction = .down
        sheetView.addGestureRecognizer(swipeGesture)
        
        nameTextField.delegate = self
        contentTextfield.delegate = self
        
        isFolder ? (nameTextField.returnKeyType = .done) : (contentTextfield.returnKeyType = .done)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sheetView.roundCorners(corners: [.topLeft, .topRight], radius: 8)
    }
    
    @objc
    private func showKeyboard(_ notification: Notification) {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            UIView.animate(withDuration: 0.3) {
                self.bottomConstraint.constant = keyboardSize.cgRectValue.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    private func hideKeyboard() {
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func swipeAction(gesture: UISwipeGestureRecognizer) {
        completion?(nil)
    }
    
    private func handleDone() -> TaskData? {
        guard let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        else { return nil }
        
        let content = contentTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return .init(name: name, content: content ?? "")
    }
}

extension AlertViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            if !isFolder {
                contentTextfield.becomeFirstResponder()
            } else {
                hideKeyboard()
                completion?(handleDone())
            }
        } else {
            hideKeyboard()
            completion?(handleDone())
        }
        return true
    }
}
