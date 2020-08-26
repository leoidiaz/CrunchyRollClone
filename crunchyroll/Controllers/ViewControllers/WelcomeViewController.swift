//
//  WelcomeViewController.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 8/25/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

protocol SegueDelegate: class {
    func switchToCreate()
    func switchToLogin()
}

class WelcomeViewController: UIViewController {
    
    //MARK: - Properties
    private let loginSegueID = "loginSegue"
    private let createSegueID = "createSegue"
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var createAccountButton: UIButton!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    func setupView(){
        logoImageView.image = #imageLiteral(resourceName: "Crunchyroll-Logo").withRenderingMode(.alwaysTemplate)
        logoImageView.tintColor = .white
        createAccountButton.layer.borderWidth = 2
        createAccountButton.layer.borderColor = UIColor.white.cgColor
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? AuthViewController else { return }
        if segue.identifier == loginSegueID {
            destinationVC.isLogin = true
            destinationVC.delegate = self
        } else if segue.identifier == createSegueID {
            destinationVC.delegate = self
            destinationVC.isLogin = false
        }
    }
}

extension WelcomeViewController: SegueDelegate {
    func switchToLogin() {
        performSegue(withIdentifier: loginSegueID, sender: Any?.self)
    }
    
    func switchToCreate() {
        performSegue(withIdentifier: createSegueID, sender: Any?.self)
    }
    
    
}
