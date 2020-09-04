//
//  HomeCollectionViewController.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 8/28/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit


class HomeCollectionViewController: UICollectionViewController {
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
//        self.collectionView!.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    //MARK: - Properties
    private let reuseIdentifier = "homeCells"
    private let segueIdentifier = "toDetailVC"
    var animes = [Anime]()

    func setupView(){
        AnimeController.fetchAnimes(searchType: .trending, query: nil) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let animes):
                    self?.animes = animes
                    self?.collectionView.reloadData()
                case .failure(let error):
                    self?.presentErrorToUser(title: "Unable to retrieve Trending Animes", localizedError: .thrownError(error))
                }
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first, let destinationVC = segue.destination as? DetailsViewController else { presentErrorToUser(title: "Unable to Segue", localizedError: .noNetwork) ; return }
            let anime = animes[indexPath.row]
            destinationVC.anime = anime
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell()}
        
        let anime = animes[indexPath.row]
        
        cell.anime = anime
        
        return cell
    }
}
