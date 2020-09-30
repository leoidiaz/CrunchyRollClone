//
//  NetworkService.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 9/30/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import Foundation

class NetworkService {
     static private let baseURL = URL(string: "https://kitsu.io/api/edge")
     static private let trendingKey = "trending"
     static private let subKey = "anime"
    //https://kitsu.io/api/edge/anime?filter[text]=demon%20slayer
     static private let queryKey = "filter[text]"
    //https://kitsu.io/api/edge/anime?page[limit]=5&page[offset]=12062

    static func fetchAnimes(searchType: AnimeFetchType, query: String?, completion: @escaping(Result<Data,CRError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        var request: URLRequest
        switch searchType {
        case .trending:
            let trendingType = baseURL.appendingPathComponent(trendingKey)
            let finalURL = trendingType.appendingPathComponent(subKey)
            request = URLRequest(url: finalURL)
        case .query:
            let animeURL = baseURL.appendingPathComponent(subKey)
            var components = URLComponents(url: animeURL, resolvingAgainstBaseURL: true)
            let searchQuery = URLQueryItem(name: queryKey, value: query)
            components?.queryItems = [searchQuery]
            guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
            request = URLRequest(url: finalURL)
        }
        resumeDataTask(withRequest: request, completion: completion)
    }
    
     static func fetchMyListAnime(idURL: String?, completion: @escaping(Result<Data, CRError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        guard let idKey = idURL else { return completion(.failure(.noData))}
        let subtype = baseURL.appendingPathComponent(subKey)
        let finalURL = subtype.appendingPathComponent(idKey)
        let request = URLRequest(url: finalURL)
        resumeDataTask(withRequest: request, completion: completion)
    }
    
    
     static func fetchPoster(posterPath: String, completion: @escaping(Result<Data, CRError>) -> Void){
        guard let posterURL = URL(string: posterPath) else { return completion(.failure(.invalidURL))}
        let request = URLRequest(url: posterURL)
        resumeDataTask(withRequest: request, completion: completion)
    }
    
     static func resumeDataTask(withRequest request: URLRequest, completion: @escaping(Result<Data, CRError>) -> Void){
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.thrownError(error)))
            } else if let data = data {
                completion(.success(data))
            }
        }
        dataTask.resume()
    }
}
