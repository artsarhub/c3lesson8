//
//  ViewController+Ext.swift
//  Lesson8
//
//  Created by Артём Сарана on 14.02.2021.
//

import UIKit

extension UIViewController {
    func show(error: Error) {
        let alertVC = UIAlertController(title: "Error",
                                        message: error.localizedDescription,
                                        preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK",
                                     style: .default)
        alertVC.addAction(okButton)
        present(alertVC, animated: true)
    }
}
