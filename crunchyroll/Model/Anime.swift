//
//  Anime.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 8/28/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import Foundation

class TopLevelObject: Decodable {
    let data: [Anime]
}

class Anime: Decodable {
    let id: String
    let attributes: Attributes
}

class Attributes: Decodable {
    let canonicalTitle: String
    let subtype: String
    let description: String
    let posterImage: PosterImage
}

class PosterImage: Decodable {
    let medium: String
    let large: String
}
