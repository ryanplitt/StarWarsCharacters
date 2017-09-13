//
//  CharacterDetailViewController.swift
//  StarWarsCharacters
//
//  Created by Ryan Plitt on 9/12/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import UIKit
import Hero

class CharacterDetailViewController: UIViewController {
    
    @IBOutlet weak var mainBackgroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var affiliationImageView: UIImageView!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var affiliationLabel: UILabel!
    @IBOutlet weak var forceSensitiveLabel: UILabel!
    
    var character: Character?
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let character = character {
            setupView(for: character)
        }
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognizer:)))
        view.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    private func setupView(for character: Character) {
        
        guard let imageURL = URL(string: character.profilePictureLink ?? ""),
        let firstName = character.firstName,
        let lastName = character.lastName,
        let birthday = character.birthdate else { return }
        
        //Profile Image
        mainBackgroundImage.kf.setImage(with: imageURL)
        mainBackgroundImage.heroID = character.profilePictureLink ?? ""
        
        //Name
        nameLabel.text = firstName + " " + lastName
        nameLabel.heroID = firstName+lastName
        
        //Affiliation Image
        affiliationImageView.image = UIImage(named: character.affiliationString ?? "")
        affiliationImageView.heroModifiers = [.fade, .translate(x: 0, y: 150, z: 0), .duration(0.6)]
        
        //Birthday Label
        birthdayLabel.text = "Birthday: \(dateFormatter.string(from: birthday as Date))"
        birthdayLabel.heroModifiers = [.translate(x: 0, y: 100, z: 0)]
        
        //Affiliation Label
        var affiliationText = "Affiliation: "
        switch character.affiliation {
        case .firstOrder:
            affiliationText += "First Order"
        case .jedi:
            affiliationText += "Jedi"
        case .resistance:
            affiliationText += "Resistance"
        case .sith:
            affiliationText += "Sith"
        default:
            break
        }
        affiliationLabel.text = affiliationText
        affiliationLabel.heroModifiers = [.translate(x: 0, y: 100, z: 0), .delay(0.1)]
        
        //Force Sensitive Label
        forceSensitiveLabel.text = "Force Sensitive: \(String(character.forceSensitive).capitalized)"
        forceSensitiveLabel.heroModifiers = [.translate(x: 0, y: 100, z: 0), .delay(0.2)]
    }
    
    func handlePan(gestureRecognizer:UIPanGestureRecognizer) {
        
        // calculate the progress based on how far the user moved
        let translation = panGestureRecognizer.translation(in: nil)
        let progress = translation.y / 2 / view.bounds.height
        
        switch panGestureRecognizer.state {
        case .began:
            // begin the transition as normal
            dismiss(animated: true, completion: nil)
        case .changed:
            Hero.shared.update(progress: Double(progress))
            
            // update views' position (limited to only vertical scroll)
            Hero.shared.apply(modifiers: [.position(CGPoint(x:mainBackgroundImage.center.x, y:translation.y + mainBackgroundImage.center.y))], to: mainBackgroundImage)
        default:
            // end or cancel the transition based on the progress and user's touch velocity
            if progress + panGestureRecognizer.velocity(in: nil).y / view.bounds.height > 0.3 {
                Hero.shared.end()
            } else {
                Hero.shared.cancel()
            }
        }
    }
    
    @IBAction func downArrowTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
