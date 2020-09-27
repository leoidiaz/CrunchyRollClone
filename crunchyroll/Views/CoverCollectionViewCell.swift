//
//  CoverCollectionViewCell.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 9/25/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class CoverCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    
    var anime: Anime? {
        didSet{
            setupCell()
        }
    }
    
    //MARK: - Helper Methods
    private func setupCell(){
        coverImageView.image = nil
        coverImageView.layer.cornerRadius = 5
        guard let anime = anime else { return }
        guard let animeCover = anime.attributes.coverImage, let tinyCover = animeCover.tiny else { return }
        AnimeController.fetchPoster(posterPath: tinyCover) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let poster):
                    self?.coverImageView.image = poster
                case .failure(let error):
                    return print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
}
