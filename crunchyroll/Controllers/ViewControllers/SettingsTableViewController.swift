//
//  SettingsTableViewController.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 9/28/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    //MARK: - Properties
    var settings = Settings.defaultSetings
    var logout:IndexPath = [1, 0]
    var deleteAccount: IndexPath = [1, 1]
    private let segueIdentifier = "settingsCell"
    
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for i in 0..<settings.count {
            if section == i {
                return settings[i].count                
            }
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Account & Profile"
        } else if section == 1 {
            return "About"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
                headerView.textLabel?.textColor = .darkGray
                headerView.tintColor = .black
            }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.textLabel?.text = settings[indexPath.section][indexPath.row]
        if indexPath == deleteAccount {
            cell.textLabel?.textColor = .red
        }
        cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.forward"))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == logout {
            do {
                try Auth.auth().signOut()
                showLogin()
            } catch {
                presentErrorToUser(title: "Unable to signout", localizedError: .thrownError(error))
            }
        }
        if indexPath == deleteAccount {
            showAlert()
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if tableView.indexPathForSelectedRow == logout || tableView.indexPathForSelectedRow == deleteAccount { return false }
        return true
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
    private func showAlert(){
        let alertController = UIAlertController(title: "Are you sure?", message: "All your saved animes will be deleted.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            UserController.shared.deleteUser { [weak self] (result) in
                switch result {
                case .success(_):
                    self?.showLogin()
                case .failure(let error):
                    self?.presentErrorToUser(title: "Unable to delete user", localizedError: .thrownError(error))
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
}
