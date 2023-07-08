//
//  UIViewController+Alertable.swift
//  Trace
//
//  Created by Horus on 2023/07/08.
//

import UIKit

protocol Alertable {
    func presentAlert(of error: Error)
}

extension UIViewController: Alertable {
    func presentAlert(of error: Error)  {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error Occured", message: "\(error)", preferredStyle: UIAlertController.Style.alert)
            let addAlertAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(addAlertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
