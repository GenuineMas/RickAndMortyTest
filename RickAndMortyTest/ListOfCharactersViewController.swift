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
    var species:String
    var gender:String
    
    
}

class ListOfCharacters : UITableViewController,UITableViewDataSourcePrefetching {
    var characters = [Character?](repeating: nil, count: 493)
    let characterID = [Int](1...493)
    var dataTasks : [URLSessionDataTask] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.dataSource = self
        tableView?.prefetchDataSource = self
    }
    
    @IBAction func sortButton(_ sender: UIBarButtonItem) {
        characters.sort(by: {$0?.name ?? "sorting name" < $1?.name ?? "sorting name"})
        tableView.reloadData()
    }
    
    func fetchCharacters(ofIndex index: Int) {
        let ID = characterID[index]
        let url = URL(string:"https://rickandmortyapi.com/api/character/\(ID)")
    
        if dataTasks.firstIndex(where: { task in task.originalRequest?.url == url }) != nil {
            return
        }
        
    
        let dataTask = URLSession.shared.dataTask(with:  url!) { data, response, error in
            if let data = data {
                print(data)
                if let jsonCharacter = try? JSONDecoder().decode(Character.self, from: data){
                    self.characters[index] = jsonCharacter
                }
            } else {
                print("No data")
                return
            }
            
            
            // Update UI on main thread
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: index, section: 0)
                if self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
                    // if the row is visible (means it is currently empty on screen, refresh it with the loaded data with fade animation
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                }
            }
        }
        
        dataTask.resume()
        dataTasks.append(dataTask)
    }
    
    func cancelFetchCharacters(ofIndex index: Int) {
        let ID = characterID[index]
        let url = URL(string:"https://rickandmortyapi.com/api/character/\(ID)")
        guard let dataTaskIndex = dataTasks.firstIndex(where: { task in
            task.originalRequest?.url == url
        }) else {
            return
        }
        
        let dataTask =  dataTasks[dataTaskIndex]
        dataTask.cancel()
        dataTasks.remove(at: dataTaskIndex)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.fetchCharacters(ofIndex: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell",for: indexPath)
        cell.textLabel?.text = characters[indexPath.row]?.name
        return cell
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            self.fetchCharacters(ofIndex: indexPath.row)
        }
    }
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            self.cancelFetchCharacters(ofIndex: indexPath.row)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailsSegue") {
            if let detailsViewController = segue.destination as? DetailsCharacterController {
                let indexPathForSelectedRow = tableView.indexPathForSelectedRow?.row
                detailsViewController.characterDetails = characters[indexPathForSelectedRow!]!
            }
        }
    }
}

