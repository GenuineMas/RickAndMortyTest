//
//  ListOfCharacters.swift
//  RickAndMortyTest
//
//  Created by Genuine on 08.04.2020.
//  Copyright © 2020 Genuine. All rights reserved.
//


import UIKit


struct Character: Codable {
    var id: Int
    var name: String
    var status: String
    var image:String
}
struct Characters: Codable {
    var results: [Character]
}
 var characters = [Character]()

class ListOfCharacters : UITableViewController {



    @IBAction func sortButton(_ sender: UIBarButtonItem) {
        characters.sort(by: {$0.name < $1.name})
                    print(characters)
                    tableView.reloadData()
    }
    

    
    override func viewDidLoad() {
        
        func parse(json: Data) {
            let decoder = JSONDecoder()
            if let jsonCharacter = try? decoder.decode(Characters.self, from: json) {
                characters = jsonCharacter.results
            }
        }
        
        super.viewDidLoad()
        let urlString = "https://rickandmortyapi.com/api/character"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell",for: indexPath)
        cell.textLabel?.text = characters[indexPath.row].name
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             if (segue.identifier == "detailsSegue") {
                 if let detailsViewController = segue.destination as? DetailsCharacterController {
                    let indexPathForSelectedRow = tableView.indexPathForSelectedRow?.row
                    detailsViewController.characterImage = characters[indexPathForSelectedRow!].image
                 }
             }
         }
}

