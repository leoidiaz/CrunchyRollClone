//
//  AnimeControllerTests.swift
//  crunchyrollTests
//
//  Created by Leonardo Diaz on 10/7/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//
@testable import crunchyroll
import XCTest

class AnimeControllerTests: XCTestCase {

    var animeController: AnimeController!
    let posterPath = "https://media.kitsu.io/anime/poster_images/1/medium.jpg?1597604210"
    override func setUp() {
        super.setUp()
        animeController = AnimeController()
    }
    
    override func tearDown() {
        super.tearDown()
        animeController = nil
    }
    
    
    func testGet_Poster(){
        let expectation = XCTestExpectation(description: "Wait for network")
        animeController.getPoster(posterPath: posterPath) { (result) in
            switch result {
            case .success(let poster):
                XCTAssertNotNil(poster)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Unable to fetch anime from mylist url, \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 30.0)
    }
    
    func testGet_Animes(){
        let expectation = XCTestExpectation(description: "Wait for network")
        animeController.getAnimes(searchType: .trending, query: nil) { (result) in
            switch result {
            case .success(let animes):
                XCTAssertNotNil(animes)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Unable to fetch anime from mylist url, \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 30.0)
    }
    
    func testGet_Anime(){
        let expectation = XCTestExpectation(description: "Wait for network")
        animeController.getMyListAnime(idURL: "1") { (result) in
            switch result {
            case .success(let anime):
                XCTAssertNotEqual(anime.id, "")
                XCTAssertEqual(anime.attributes.canonicalTitle, "Cowboy Bebop")
                XCTAssertEqual(anime.attributes.subtype, "TV")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Unable to fetch anime from mylist url, \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 30.0)
    }
    
}
