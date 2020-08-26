//
//  AuthViewController.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 8/25/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var dividerLabel: UILabel!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    
    @IBOutlet weak var loginCreateButton: UIButton!
    
    //MARK: - Properties
    var isLogin: Bool!
    weak var delegate: SegueDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        emailTextField.becomeFirstResponder()
        loginCreateButton.layer.borderWidth = 2
        loginCreateButton.layer.borderColor = UIColor.white.cgColor
        if isLogin {
            loginCreateButton.setTitle("LOG IN", for: .normal)
        } else {
            loginCreateButton.setTitle("CREATE ACCOUNT", for: .normal)
            forgotPassword.isHidden = true
            dividerLabel.text = "Already have an account? "
            accountButton.setTitle("Log In", for: .normal)
        }
    }
    
    @IBAction func accountSwitch(_ sender: Any) {
        if isLogin {
            dismiss(animated: true) { [weak self] in
                self?.delegate?.switchToCreate()
            }
        } else {
            dismiss(animated: true) { [weak self] in
                self?.delegate?.switchToLogin()
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
