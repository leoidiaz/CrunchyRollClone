//
//  ViewControllerExtension.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 8/28/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentErrorToUser(title: String, localizedError: CRError) {
        let alertController = UIAlertController(title: title, message: localizedError.errorDescription, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
}
