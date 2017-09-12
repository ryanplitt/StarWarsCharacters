//
//  CharacterListViewController.swift
//  StarWarsCharacters
//
//  Created by Ryan Plitt on 9/12/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import UIKit
import Sync
import CoreData
import DATASource
import Kingfisher


class CharacterListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var dataStack: DataStack = DataStack(modelName: "Model")
    
    var characters = [Character]()
    
    lazy var dataSource: DATASource = {
        
        let request: NSFetchRequest<Character> = Character.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
        
        let dataSource = DATASource(tableView: self.tableView, cellIdentifier: "characterCell", fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>, mainContext: self.dataStack.mainContext, configuration: { (cell, managedObject, indexPath) in
            guard let character = managedObject as? Character,
            let cell = cell as? CharacterTableViewCell,
                let imageURL = URL(string: character.profilePictureLink!) else { return }
            cell.character = character
            cell.characterImageView.kf.setImage(with: imageURL)
        })
        
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = self
        fetchNewData()
    }
    
    
    func fetchNewData() {
        let url = URL(string: "https://edge.ldscdn.org/mobile/interview/directory")!
        let data = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error { print("There was an error fetching the data: \(error.localizedDescription)") ; return }
            guard let data = data,
                let jsonDictionary = try! JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any],
                let arrayOfCharacters = jsonDictionary["individuals"] as? [[String : Any]] else { print("Unable to parse data."); return }
            
            Sync.changes(arrayOfCharacters, inEntityNamed: "Character", dataStack: self.dataStack, completion: { (error) in
                if let error = error {
                    print("There was an error syncing the changes: \n\(error.localizedDescription)")
                    print(error)
                }
            })
        }
        
        data.resume()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
