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
    case myList
}

class AnimeController {
    static private let baseURL = URL(string: "https://kitsu.io/api/edge")
    static private let trendingKey = "trending"
    static private let subKey = "anime"
    
    static func fetchAnimes(searchType: AnimeFetchType, query: String?, idURL: String?, completion: @escaping(Result<[Anime],CRError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        
        switch searchType {
        case .trending:
            let trendingType = baseURL.appendingPathComponent(trendingKey)
            let finalURL = trendingType.appendingPathComponent(subKey)
            URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    completion(.failure(.thrownError(error)))
                }

                guard let data = data else { return completion(.failure(.noData))}
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
                
            }.resume()
        case .query:
            print("Query")
        case .myList:
            guard let urlString = idURL else { return completion(.failure(.noData))}
            guard let finalURL = URL(string: urlString) else { return completion(.failure(.invalidURL))}
            
            URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    completion(.failure(.thrownError(error)))
                }

                guard let data = data else { return completion(.failure(.noData))}
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
                
            }.resume()
        }
    }
    
    static func fetchPoster(posterPath: String, completion: @escaping(Result<UIImage, CRError>) -> Void){
        guard let posterURL = URL(string: posterPath) else { return completion(.failure(.invalidURL))}
        URLSession.shared.dataTask(with: posterURL) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.thrownError(error)))
            }
            guard let data = data else { return completion(.failure(.noData))}
            guard let poster = UIImage(data: data) else { return completion(.failure(.noData))}
            return completion(.success(poster))
        }.resume()
    }
}
