//
//  AlertShowable.swift
//  Gurme
//
//  Created by Emre Koçak on 10.03.2026.
//

import UIKit

struct AlertArguments {
    let title: String
    let message: String
    let buttonTitle: String
}

protocol AlertShowable {
    func showAlert(arguments: AlertArguments)
}

extension AlertShowable where Self: UIViewController {
    func showAlert(arguments: AlertArguments) {
        let alertController = UIAlertController(
            title: arguments.title,
            message: arguments.message,
            preferredStyle: .alert
        )

        let alertAction = UIAlertAction(
            title: arguments.buttonTitle,
            style: .default
        )
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
}
