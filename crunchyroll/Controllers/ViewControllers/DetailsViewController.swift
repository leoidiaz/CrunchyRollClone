//
//  DetailsViewController.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 9/3/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import Firebase

class DetailsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTypeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var bookMarkStatusLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    //MARK: - Properties
    var anime: Anime?
    var timer: Timer?
    var animeID: String?
    private let notificationName = "refreshList"
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        setup()
    }
    //MARK: - Helper Methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setup(){
        guard let anime = anime else { return }
        animeID = anime.id
        if UserController.shared.mylist.contains(anime.id){ bookmarkButton.isSelected = true}
        bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        titleLabel.text = anime.attributes.canonicalTitle
        subTypeLabel.text = anime.attributes.subtype
        descriptionLabel.text = anime.attributes.description
        
        fetchPoster(anime: anime)
    }
    
    private func fetchPoster(anime: Anime){
        AnimeController.getPoster(posterPath: anime.attributes.posterImage.large) { [weak self] (result) in
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
    
    private func style(){
        topBarView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        bookmarkButton.layer.borderColor = #colorLiteral(red: 1, green: 0.4199070632, blue: 0.1084215119, alpha: 1)
        bookmarkButton.layer.borderWidth = 2
    }
    
    private func setTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] (_) in
            self?.bookmarkLabelChange()
        })
    }
    
    private func bookmarkLabelChange(isHidden: Bool = true, constant: CGFloat = .zero){
        bottomConstraint.constant = constant
        bookMarkStatusLabel.isHidden = isHidden
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        timer?.invalidate()
        dismiss(animated: true)
    }
    
    @IBAction func bookmarkButtonTapped(_ sender: Any) {
        timer?.invalidate()
        guard let animeID = animeID else { return }
        bookmarkLabelChange(isHidden: false, constant: 10.0)
        bookmarkButton.backgroundColor = .black

        if bookmarkButton.isSelected {
            UserController.shared.removeFromList(animeID: animeID)
            bookmarkButton.isSelected = false
            bookMarkStatusLabel.text = "Removed from watchlist"
        } else {
            UserController.shared.addToList(animeID: animeID)
            bookmarkButton.isSelected = true
            bookMarkStatusLabel.text = "Added to Watchlist"
        }
        NotificationCenter.default.post(name: Notification.Name(notificationName), object: nil)
        setTimer()
    }
    @IBAction func onBookMarkTouch(_ sender: Any) {
        bookmarkButton.backgroundColor = #colorLiteral(red: 1, green: 0.4199070632, blue: 0.1084215119, alpha: 1)
    }
}
