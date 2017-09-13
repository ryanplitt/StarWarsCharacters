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
import CBStoreHouseRefreshControl


class CharacterListViewController: UIViewController, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var cbRefreshControl = CBStoreHouseRefreshControl()
    
    var dataStack: DataStack = DataStack(modelName: "Model")
    
    var characters = [Character]()
    
    // the datasource (fetchedResultsController)
    lazy var dataSource: DATASource = {
        
        let request: NSFetchRequest<Character> = Character.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
        
        let dataSource = DATASource(tableView: self.tableView, cellIdentifier: "characterCell", fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>, mainContext: self.dataStack.mainContext, configuration: { (cell, managedObject, indexPath) in
            guard let character = managedObject as? Character,
            let cell = cell as? CharacterTableViewCell,
                let imageURL = URL(string: character.profilePictureLink!) else { return }
            cell.character = character
            
            cell.characterImageView.kf.indicatorType = .activity
            cell.characterImageView.kf.setImage(with: imageURL)
        })
        
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = self
        fetchNewData()
        
        // add pull-to-refresh
        cbRefreshControl = CBStoreHouseRefreshControl.attach(to: tableView, target: self, refreshAction: #selector(fetchNewData), plist: "tieFighter", color: .white, lineWidth: 3, dropHeight: 100, scale: 1.2, horizontalRandomness: 170, reverseLoadingAnimation: false, internalAnimationFactor: 0.3)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        // remove selection
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: false)
        }
    }
    
    
    func fetchNewData() {
        guard let url = URL(string: "https://edge.ldscdn.org/mobile/interview/directory") else { return }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let datatask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("There was an error fetching the data: \(error.localizedDescription)")
                self.cbRefreshControl.finishingLoading()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                return
            }
            
            guard let data = data,
                let jsonDictionary = try! JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any],
                let arrayOfCharacters = jsonDictionary["individuals"] as? [[String : Any]] else { print("Unable to parse data."); return }
            
            // Use Sync to sync the changes between the json (arrayOfCharacters) and what is currently in core data. The completion will fire when new entries have been added, old entries have been deleted, and existing entries have been modified (if any). Our DATASource (FetchedResultsController) will take care of the rest for updating the tableView appropriately.
            
            Sync.changes(arrayOfCharacters, inEntityNamed: "Character", dataStack: self.dataStack, completion: { (error) in
                if let error = error {
                    print("There was an error syncing the changes: \n\(error.localizedDescription)")
                    print(error)
                }
                self.cbRefreshControl.finishingLoading()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        }
        
        datatask.resume()
    }
    
    // MARK: - TableViewDelegate / ScrollViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        cbRefreshControl.scrollViewDidEndDragging()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        cbRefreshControl.scrollViewDidScroll()
    }

    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentCell = sender as? CharacterTableViewCell,
            let vc = segue.destination as? CharacterDetailViewController else { return }
        vc.character = currentCell.character
    }


}
