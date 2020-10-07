//
//  AnimeController.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 8/28/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit.UIImage

enum AnimeFetchType {
    case trending
    case query
}

class AnimeController {
    
    var network = NetworkService()
    
    //MARK: - Decoding
     func getAnimes(searchType: AnimeFetchType, query: String?, completion: @escaping(Result<[Anime], CRError>) -> Void) {
        network.fetchAnimes(searchType: searchType, query: query) { (result) in
            switch result {
            case .success(let data):
                do {
                    let anime = try JSONDecoder().decode(TopLevelObject.self, from: data)
                    var animes = [Anime]()
                    for anime in anime.data {
                        animes.append(anime)
                    }
                    return completion(.success(animes))
                } catch {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    return completion(.failure(.thrownError(error)))
                }
            case .failure(let error):
                completion(.failure(.thrownError(error)))
            }
        }
    }
    
     func getMyListAnime(idURL: String, completion: @escaping(Result<Anime, CRError>) -> Void) {
        network.fetchMyListAnime(idURL: idURL) { (result) in
            switch result {
            case .success(let data):
                do {
                    let topLevel = try JSONDecoder().decode(MyListLevelObject.self, from: data)
                    let anime = topLevel.data
                    return completion(.success(anime))
                } catch {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    return completion(.failure(.thrownError(error)))
                }
            case .failure(let error):
                completion(.failure(.thrownError(error)))
            }
        }
    }
    
    func getPoster(posterPath: String, completion: @escaping(Result<UIImage, CRError>) -> Void) {
        network.fetchPoster(posterPath: posterPath) { (result) in
            switch result{
            case .success(let data):
                guard let poster = UIImage(data: data) else { return completion(.failure(.noData))}
                return completion(.success(poster))
            case .failure(let error):
                return completion(.failure(.thrownError(error)))
            }
        }
    }
}
