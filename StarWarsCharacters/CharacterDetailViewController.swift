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
    
    var character: Character?
    
    var panGestureRecognizer: UIPanGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let character = character, let imageURL = URL(string: character.profilePictureLink!) {
            mainBackgroundImage.kf.setImage(with: imageURL)
            mainBackgroundImage.heroID = character.profilePictureLink!
            nameLabel.text = character.firstName! + " " + character.lastName!
            nameLabel.heroID = character.firstName!+character.lastName!
            affiliationImageView.image = UIImage(named: character.affiliationString!)
            affiliationImageView.heroModifiers = [.fade, .translate(x: 0, y: 150, z: 0), .duration(0.6)]
            view.heroModifiers = [.fade]
        }
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognizer:)))
        view.addGestureRecognizer(panGestureRecognizer)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
