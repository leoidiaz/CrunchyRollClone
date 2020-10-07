//
//  NetworkServiceTests.swift
//  crunchyrollTests
//
//  Created by Leonardo Diaz on 10/7/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

@testable import crunchyroll
import XCTest

class NetworkServiceTests: XCTestCase {
    let baseURL = URL(string: "https://kitsu.io/api/edge")
    let posterPath = "https://media.kitsu.io/anime/poster_images/1/medium.jpg?1597604210"
    let trendingKey = "trending"
    let subKey = "anime"
    var network: NetworkService!
    
    override func setUp() {
        super.setUp()
        network = NetworkService()
    }
    
    override func tearDown() {
        super.tearDown()
        network = nil
    }
    
    func testData_Task() {
        let expectation = XCTestExpectation(description: "Wait for network")
        guard let baseURL = baseURL else { XCTFail("Unable to turn baseURL string to URL") ; return }
        let trendingType = baseURL.appendingPathComponent(trendingKey)
        let finalURL = trendingType.appendingPathComponent(subKey)
        let urlRequest = URLRequest(url: finalURL)
        network.resumeDataTask(withRequest: urlRequest) { (result) in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Unable to fetch animes from url, \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testCheck_URL() {
        guard let baseURL = baseURL else { XCTFail("Unable to turn baseURL string to URL") ; return }
        let trendingType = baseURL.appendingPathComponent(trendingKey)
        let finalURL = trendingType.appendingPathComponent(subKey)
        XCTAssertEqual(finalURL, URL(string: "https://kitsu.io/api/edge/trending/anime"))
    }
    
    
    func testFetch_trending() {
        let expectation = XCTestExpectation(description: "Wait for network")
        network.fetchAnimes(searchType: .trending, query: nil) { (result) in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Unable to fetch animes from url, \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 30.0)
    }
    
    func testFetchMyListAnime() {
        let expectation = XCTestExpectation(description: "Wait for network")
        network.fetchMyListAnime(idURL: "1") { (result) in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Unable to fetch anime from mylist url, \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 30.0)
    }
    
    func testFetchPoster() {
        let expectation = XCTestExpectation(description: "Wait for network")
        network.fetchPoster(posterPath: posterPath) { (result) in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Unable to fetch anime from mylist url, \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 30.0)
    }
}
