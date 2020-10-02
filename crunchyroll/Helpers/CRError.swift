//
//  CRError.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 8/28/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import Foundation

enum CRError: LocalizedError {
    case invalidURL
    case thrownError(Error)
    case noData
    case noNetwork
    case emptyTextField
    case emailDoesNotMatch
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Unable to reach server."
        case .thrownError(let error):
            return error.localizedDescription
        case .noData:
            return "The server responded with no data."
        case .emptyTextField:
            return "You can't add an empty textfield."
        case .noNetwork:
            return "Please check your network connection."
        case .emailDoesNotMatch:
            return "Please check your Email field and make sure they match"
        }
    }
}
