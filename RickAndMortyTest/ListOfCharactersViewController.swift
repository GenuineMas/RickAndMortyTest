//
//  ListOfCharacters.swift
//  RickAndMortyTest
//
//  Created by Genuine on 08.04.2020.
//  Copyright © 2020 Genuine. All rights reserved.
//


import UIKit

class ListOfCharacters : UITableViewController {
  
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell",for: indexPath)
        cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        return cell
    }
    

    
}
