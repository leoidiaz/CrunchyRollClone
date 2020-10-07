//
//  ResetPasswordViewController.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 10/7/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var currentInfo: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    //MARK: - Helper Methods
    private func setupView(){
        currentInfo.delegate = self
        currentInfo.backgroundColor = #colorLiteral(red: 0, green: 0.299513787, blue: 0.4791773558, alpha: 1)
        addPaddingAndBorder(to: currentInfo)
        currentInfo.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "GillSans", size: 18)!])
    }
    //MARK: - IB Actions
    @IBAction func resetTapped(_ sender: Any) {
        guard let email = currentInfo.text, !email.isEmpty else { presentErrorToUser(title: "Email Field Error", localizedError: .emptyTextField) ; return}
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] (error) in
            if let error = error {
                self?.presentErrorToUser(title: "Error updating password", localizedError: .thrownError(error))
                return
            }
            self?.dismiss(animated: true)
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
    //MARK: - UITextField Delegates
extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if currentInfo.isFirstResponder {
            currentInfo.setBottomBorder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currentInfo.resignFirstResponder()
        currentInfo.removeBottomBorder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentInfo.endEditing(true)
        currentInfo.removeBottomBorder()
    }
}
