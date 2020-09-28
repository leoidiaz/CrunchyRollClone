//
//  HomeViewController.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 9/25/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    @IBOutlet weak var coverImageCollectionView: UICollectionView!
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchAnimes()
        retrieveMyList()
    }
    
    //MARK: - Properties
    private let reuseIdentifier = "homeCells"
    private let coverAnimeIdentifier = "coverAnimeCell"
    private let searchViewIdentifier = "toSearchVC"
    private let segueIdentifier = "toDetailVC"
    private var coverImageAnimes = [Anime]()
    private var animes = [Anime]()
    
    private func setupView(){
        trendingCollectionView.delegate = self
        trendingCollectionView.dataSource = self
        coverImageCollectionView.delegate = self
        coverImageCollectionView.dataSource = self
        coverImageCollectionView.isPagingEnabled = true
    }
    
    private func fetchAnimes(){
        AnimeController.fetchAnimes(searchType: .trending, query: nil) { [weak self] (result) in
            DispatchQueue.main.sync {
                switch result {
                case .success(let animes):
                    self?.animes = animes
                    self?.trendingCollectionView.reloadData()
                    self?.coverImageCollectionView.reloadData()
                case .failure(let error):
                    self?.presentErrorToUser(title: "Unable to retrieve Trending Animes", localizedError: .thrownError(error))
                }
            }
        }
    }
    
    private func retrieveMyList(){
        UserController.shared.fetchMyList { [weak self] (result) in
            switch result {
            case .success(_):
                return
            case .failure(let error):
                self?.presentErrorToUser(title: "Unable to retrieve my list", localizedError: .thrownError(error))
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            guard let indexPath = trendingCollectionView.indexPathsForSelectedItems?.first, let destinationVC = segue.destination as? DetailsViewController else { presentErrorToUser(title: "Unable to Segue", localizedError: .noNetwork) ; return }
            let anime = animes[indexPath.row]
            destinationVC.anime = anime
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == trendingCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell()}
            let anime = animes[indexPath.row]
            cell.anime = anime
            return cell
        }
        if collectionView == coverImageCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: coverAnimeIdentifier, for: indexPath) as? CoverCollectionViewCell else { return UICollectionViewCell()}
            let anime = animes[indexPath.row]
            cell.anime = anime
            return cell
        }
        return UICollectionViewCell()
    }
}
