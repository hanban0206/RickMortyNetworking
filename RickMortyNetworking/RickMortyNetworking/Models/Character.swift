//
//  Character.swift
//  RickMortyNetworking
//
//  Created by Michael McGrath on 7/7/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

struct CharacterSearch: Decodable {
    let results: [Character]
}

struct Character: Decodable {
    let id: Int
    let name: String
    let species: String
    let type: String
    let gender: String
    let image: URL
}
