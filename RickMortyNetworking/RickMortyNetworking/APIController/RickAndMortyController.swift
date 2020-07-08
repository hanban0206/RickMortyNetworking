//
//  RickAndMortyController.swift
//  RickMortyNetworking
//
//  Created by Michael McGrath on 7/7/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

class RickAndMortyController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    private let baseURL = URL(string: "https://rickandmortyapi.com")!
    private lazy var characterURL = URL(string: "/api/character", relativeTo: baseURL)!
    
    var characters: [Character] = []
    var queryItems: [URLQueryItem] = []
    
    func getCharacters(completion: @escaping (Error?) -> Void) {

        var request = URLRequest(url: characterURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print("Bad response code: \(response)")
                completion(error)
                return
            }
            
            if let error = error {
                print("Error fetching characters: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("Bad or no data returned from data task")
                completion(error)
                return
            }
            
            do {
                let characterSearch = try JSONDecoder().decode(CharacterSearch.self, from: data)
//                self.characters = characterSearch.results
                characterSearch.results.forEach { character in
                    self.characters.append(character)
                }
                completion(nil)
            } catch {
                print("Error decoding character objects: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    func getFilterQueryItems(name: String?, status: Status?, gender: Gender?) {
        
        var items: [URLQueryItem] = []
        
        if let name = name {
            let nameQuery = URLQueryItem(name: "name", value: name)
            items.append(nameQuery)
        }
        
        if let status = status {
            let statusQuery = URLQueryItem(name: "status", value: status.rawValue)
            items.append(statusQuery)
        }
        
        if let gender = gender {
            let genderQuery = URLQueryItem(name: "gender", value: gender.rawValue)
            items.append(genderQuery)
        }
        self.queryItems = items
    }
    
    func filteredCharacterSearch(queryItems: [URLQueryItem], completion: @escaping (Error?) -> Void) {

        var urlComponents = URLComponents(url: characterURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        
        guard let requestURL = urlComponents?.url else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print("Bad response code: \(response)")
                completion(error)
                return
            }
            
            if let error = error {
                print("Error fetching filtered characters: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("Bad or no data returned from data task")
                completion(error)
                return
            }
            
            // I like to show this as its a convenient way to print the json you are trying to parse and in my opinion looks better than pretty printed
            let json = try! JSONSerialization.jsonObject(with: data)
            print(json)
            
            do {
                let filteredSearch = try JSONDecoder().decode(CharacterSearch.self, from: data)
                filteredSearch.results.forEach { character in
                    self.characters.append(character)
                }
                completion(nil)
            } catch {
                print("Error decoding character objects: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
}
