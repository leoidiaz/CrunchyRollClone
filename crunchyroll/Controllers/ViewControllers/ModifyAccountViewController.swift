//
//  ModifyAccountViewController.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 10/1/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import Firebase

class ModifyAccountViewController: UIViewController {
    @IBOutlet weak var currentInfo: UITextField!
    @IBOutlet weak var changingButton: UIButton!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        currentInfo.backgroundColor = #colorLiteral(red: 0, green: 0.299513787, blue: 0.4791773558, alpha: 1)
        addPaddingAndBorder(to: currentInfo)
        currentInfo.attributedPlaceholder = NSAttributedString(string: "Current Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "GillSans", size: 18)!])
        changingButton.setTitleColor(.white, for: .normal)
        changingButton.backgroundColor = #colorLiteral(red: 1, green: 0.3746894228, blue: 0.1007378142, alpha: 1)
        changingButton.setTitle("CHANGE PASSWORD", for: .normal)
    }
    
    @IBAction func modifyAccountTapped(_ sender: Any) {
        guard currentInfo.text == Auth.auth().currentUser?.email else { presentErrorToUser(title: "Confirm Current Email Incorrect", localizedError: .emailDoesNotMatch) ; return }
        guard let email = currentInfo.text, !email.isEmpty else { presentErrorToUser(title: "Email Field Error", localizedError: .emptyTextField) ; return}
            Auth.auth().sendPasswordReset(withEmail: email) { [weak self] (error) in
                if let error = error {
                    self?.presentErrorToUser(title: "Error updating password", localizedError: .thrownError(error))
                    return
                }
                do {
                    try Auth.auth().signOut()
                    self?.showLogin()
                } catch {
                    self?.presentErrorToUser(title: "Unable to signout", localizedError: .thrownError(error))
                    return
                }
            }
        }
    
    //MARK: - Helper Methods
    
    private func showLogin(){
        let welcomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "loginVC")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window {
            dismiss(animated: true) {
                window.rootViewController = welcomeViewController
            }
        }
    }
}
