//
//  CharacterTableViewCell.swift
//  StarWarsCharacters
//
//  Created by Ryan Plitt on 9/12/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import UIKit
import Hero

class CharacterTableViewCell: UITableViewCell {


    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var character: Character? {
        didSet{
            guard let character = character,
                let firstName = character.firstName,
                let lastName = character.lastName else { return }
            nameLabel.text = firstName + " " + lastName
            
            // set Hero ID's so that it knows how to transition to the matching ID in the CharacterDetailViewController
            characterImageView.heroID = character.profilePictureLink ?? ""
            nameLabel.heroID = firstName+lastName
        }
    }
}
