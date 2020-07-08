//
//  ViewController.swift
//  RickMortyNetworking
//
//  Created by Shawn Gee on 7/8/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let rickAndMortyController = RickAndMortyController()
    
    @IBOutlet weak var testImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testNetworking()
    }

    func testNetworking() {
        rickAndMortyController.getCharacters { _ in
            
        }
        
        rickAndMortyController.getFilterQueryItems(name: "rick", status: Status(rawValue: Status.alive.rawValue), gender: nil)
        let items = rickAndMortyController.queryItems
        
        rickAndMortyController.filteredCharacterSearch(queryItems: items) { _ in
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    func updateView() {
        guard let first = rickAndMortyController.characters.first else { return }
        let data = try! Data(contentsOf: first.image)
        testImageView.image = UIImage(data: data)
    }

}

