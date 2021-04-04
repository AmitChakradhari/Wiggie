//
//  Model.swift
//  Wiggie
//
//  Created by Amit  Chakradhari on 04/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import UIKit

//struct MovieItem: Hashable {
//
//
//
//    let image: UIImage?
//    let label: String?
//}

struct MovieItem: Codable, Hashable {
    
    private let identifier = UUID()
    
    static func == (lhs: MovieItem, rhs: MovieItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    let Title: String?
    let Year: String?
    let imdbID: String?
    let `Type`: String?
    let Poster: String?
}

struct MovieResponse: Codable {
    let Search: [MovieItem]?
    let totalResults: String?
    let Response: String?
    let Error: String?
}

