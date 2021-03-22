//
//  DetailsCharacterController.swift
//  RickAndMortyTest
//
//  Created by Genuine on 08.04.2020.
//  Copyright © 2020 Genuine. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa



class DetailsCharacterCell: UITableViewCell {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var SpeciesLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsImage: UIImageView!
    
    
}


class DetailsCharacterController: UITableViewController {
    
    var characterImage: String = ""
    var characterDetails = Character? (nil)
    
    override func viewDidLoad() {
      
        tableView.estimatedRowHeight = 600
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsOfCharacter", for: indexPath) as! DetailsCharacterCell
        cell.detailsImage.load(url: URL(string: characterDetails!.image)!)
        cell.genderLabel.text = characterDetails?.gender
        cell.nameLabel.text = characterDetails?.name
        cell.statusLabel.text = characterDetails?.status
        cell.SpeciesLabel.text = characterDetails?.species
        return cell
    }
}


