//
//  SearchViewController.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 9/16/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var animeQueryBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resultsLabel: UILabel!
    
    var animes = [Anime]()
    private let reuseID = "searchedAnime"
    private let segueIdentifier = "detailsFromSearchVC"
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    //MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    //MARK: - Helper Methods
    private func fetchAnime(anime: String){
        AnimeController.getAnimes(searchType: .query, query: anime) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let animes):
                    self?.animes = animes
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.presentErrorToUser(title: "Search Error", localizedError: .thrownError(error))
                }
            }
        }
    }
    
    private func setupView(){
        animeQueryBar.becomeFirstResponder()
        tableView.delegate = self
        tableView.dataSource = self
        animeQueryBar.delegate = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            guard let indexPath = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? DetailsViewController else { presentErrorToUser(title: "Unable to Segue", localizedError: .noNetwork) ; return }
            let anime = animes[indexPath.row]
            destinationVC.anime = anime
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }

}

    //MARK: - Tableview Delegates
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? SearchTableViewCell else { return UITableViewCell()}
        let anime = animes[indexPath.row]
        cell.anime = anime
        return cell
    }
}

    //MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        fetchAnime(anime: searchTerm)
        resultsLabel.isHidden = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return}
        if searchText.isEmpty{
            resultsLabel.isHidden = true
            animes.removeAll()
            tableView.reloadData()
        }
    }
}
