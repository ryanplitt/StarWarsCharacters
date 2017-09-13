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
            guard let character = character else { return }
            nameLabel.text = character.firstName! + " " + character.lastName!
            characterImageView.heroID = character.profilePictureLink!
            nameLabel.heroID = character.firstName!+character.lastName!
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
