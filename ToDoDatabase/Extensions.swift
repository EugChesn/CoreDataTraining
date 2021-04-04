//
//  Extensions.swift
//  ToDoDatabase
//
//  Created by EvgeniiChistyakov on 02.04.2021.
//

import Foundation
import UIKit

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UserDefaults {
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
        }
        return isFirstLaunch
    }
}

extension Date
{
    func toString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter.string(from: self)
    }
}

extension UIViewController {
    func presentInputPopUp(isFolder: Bool = false, completion: @escaping (TaskData) -> Void
) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as? AlertViewController {
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .coverVertical
            
            alertVC.isFolder = isFolder
            alertVC.completion = { [weak self] result in
                UIView.animate(withDuration: 0.4) {
                    self?.view.alpha = 1
                }
                self?.dismiss(animated: true, completion: nil)
                
                if let result = result {
                    completion(result)
                }
            }
            
            UIView.animate(withDuration: 0.4) {
                self.view.alpha = 0.4
            }
            present(alertVC, animated: true)
        }
    }
}
