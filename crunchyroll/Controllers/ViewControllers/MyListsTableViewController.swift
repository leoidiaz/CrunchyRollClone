//
//  MyListsTableViewController.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 9/22/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class MyListsTableViewController: UITableViewController {
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMyList()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchMyList), name: Notification.Name(notificationName), object: nil)
    }
    
    //MARK: - Properties
    private let reuseIdentifier = "myListCells"
    private let segueIdentifier = "detailsFromMyListVC"
    private let notificationName = "refreshList"
    var animes = [Anime]() {
        didSet{
            if animes.count == UserController.shared.mylist.count {
                tableView.reloadData()
            }
        }
    }
    
    //MARK: - Helper Methods
    
    @objc private func fetchMyList(){
        animes.removeAll()
        guard !UserController.shared.mylist.isEmpty else { return }
        for animeURL in UserController.shared.mylist {
            AnimeController.fetchMyListAnime(idURL: animeURL) { [weak self] (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let anime):
                        self?.animes.append(anime)
                    case .failure(let error):
                        self?.presentErrorToUser(title: "Unable to retrieve my list", localizedError: .thrownError(error))
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell()}
        let anime = animes[indexPath.row]
        cell.anime = anime
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            guard let indexPath = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? DetailsViewController else { presentErrorToUser(title: "Unable to Segue", localizedError: .noNetwork) ; return }
            let anime = animes[indexPath.row]
            destinationVC.anime = anime
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}
