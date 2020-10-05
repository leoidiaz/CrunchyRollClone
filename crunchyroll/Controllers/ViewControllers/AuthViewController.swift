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
    @IBOutlet weak var accountLabel: UILabel!
    
    //MARK: - Properties
    var isLogin: Bool!
    weak var delegate: SegueDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupView(){
        emailTextField.becomeFirstResponder()
        loginCreateButton.layer.borderWidth = 2
        loginCreateButton.layer.borderColor = UIColor.white.cgColor
        addPaddingAndBorder(to: emailTextField)
        addPaddingAndBorder(to: passwordTextField)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "GillSans", size: 18)!])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "GillSans", size: 18)!])
        if isLogin {
            loginCreateButton.setTitle("LOG IN", for: .normal)
            accountLabel.text = "Log In"
        } else {
            accountLabel.text = "Create Account"
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
    
    @IBAction func loginCreateButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else { presentErrorToUser(title: "Email is empty", localizedError: .emptyTextField) ; return }
        guard let password = passwordTextField.text, !password.isEmpty else { presentErrorToUser(title: "Password is empty", localizedError: .emptyTextField) ; return }
        
        if isLogin {
            
            UserController.shared.signInUser(email: email, password: password) { [weak self] (result) in
                switch result {
                case .success(_):
                    self?.showMain()
                case .failure(let error):
                    self?.presentErrorToUser(title: "Error signing in.", localizedError: .thrownError(error))
                    return
                }
            }
        } else {
            UserController.shared.createAuthUser(email: email, password: password) { [weak self] (result) in
                switch result {
                case .success(_):
                    self?.showMain()
                case .failure(let error):
                    self?.presentErrorToUser(title: "Error Creating account.", localizedError: .thrownError(error))
                    return
                }
            }
        }
    }
    
    private func showMain(){
        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "homeVC")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window {
            dismiss(animated: true) {
                window.rootViewController = homeViewController
            }
        }
    }
    
}
