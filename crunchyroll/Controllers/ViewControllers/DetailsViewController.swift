//
//  DetailsViewController.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 9/3/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTypeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    
    var anime: Anime?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        setup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setup(){
        guard let anime = anime else { return }
        
        titleLabel.text = anime.attributes.canonicalTitle
        subTypeLabel.text = anime.attributes.subtype
        descriptionLabel.text = anime.attributes.description
        
        fetchPoster(anime: anime)
    }
    
    private func fetchPoster(anime: Anime){
        AnimeController.fetchPoster(posterPath: anime.attributes.posterImage.large) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let poster):
                    self?.posterImageView.image = poster
                case .failure(let error):
                    self?.presentErrorToUser(title: "No Image Found", localizedError: .thrownError(error))
                }
            }
        }
    }
    
    func style(){
        topBarView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        bookmarkButton.layer.borderColor = #colorLiteral(red: 1, green: 0.4199070632, blue: 0.1084215119, alpha: 1)
        bookmarkButton.layer.borderWidth = 2
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
