//
//  CharacterCell.swift
//  RickMortyNetworking
//
//  Created by Shawn Gee on 7/9/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var speciesLabel: UILabel!
    
    // MARK: - Public Properties
    
    var character: Character? { didSet { updateViews() }}
    var apiController: RickAndMortyController?
    
    
    func updateViews() {
        guard let character = character else { return }
        apiController?.getImage(imageURL: character.image) { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        
        self.nameLabel.text = character.name
        self.speciesLabel.text = character.species
    }
}
