//
//  TrendingCollectionViewCell.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 8/28/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class TrendingCollectionViewCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    //MARK: - Properties
    var anime: Anime? {
        didSet{
            setupCell()
        }
    }
    //MARK: - Helper Methods
    private func setupCell(){
        guard let anime = anime else { return }
        titleLabel.text = anime.attributes.canonicalTitle
        typeLabel.text = anime.attributes.subtype
        posterImageView.image = nil
        AnimeController.getPoster(posterPath: anime.attributes.posterImage.medium) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let poster):
                    self?.posterImageView.image = poster
                case .failure(let error):
                    return print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
}
