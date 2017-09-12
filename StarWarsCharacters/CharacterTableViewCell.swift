//
//  CharacterTableViewCell.swift
//  StarWarsCharacters
//
//  Created by Ryan Plitt on 9/12/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {

    @IBOutlet weak var affiliationImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    var character: Character? {
        didSet{
            guard let character = character else { return }
            affiliationImageView.image = UIImage(named: character.affiliationString!)
            nameLabel.text = character.firstName! + " " + character.lastName!
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
