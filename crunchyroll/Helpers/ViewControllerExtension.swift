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

extension UIBarButtonItem {
    static func logoButton(_ target: Any?, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isUserInteractionEnabled = false
        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 110).isActive = true
        return menuBarItem
    }
}

func createGradient(frame: CGRect) -> CAGradientLayer{
    let gradient = CAGradientLayer()
    gradient.frame = frame
    gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
    gradient.locations = [0, 0.1, 0.9, 1]
    return gradient
}

func addPaddingAndBorder(to textfield: UITextField) {
    let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 2.0))
    textfield.leftView = leftView
    textfield.leftViewMode = .always
}
