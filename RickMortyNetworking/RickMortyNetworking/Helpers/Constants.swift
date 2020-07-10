//
//  Constants.swift
//  RickMortyNetworking
//
//  Created by Michael McGrath on 7/7/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

enum Status: String, CaseIterable {
    case alive = "alive"
    case dead = "dead"
    case unknown = "unknown"
}

enum Gender: String, CaseIterable {
    case femail = "female"
    case male = "male"
    case genderless = "genderless"
    case unknown = "unknown"
}
