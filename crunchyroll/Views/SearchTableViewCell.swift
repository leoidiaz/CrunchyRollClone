//
//  SearchTableViewCell.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 9/18/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var moreInfoButton: UIButton!
    var animeController = AnimeController()
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
        animeController.getPoster(posterPath: anime.attributes.posterImage.medium) { [weak self] (result) in
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
