//
//  ListOfCharacters.swift
//  RickAndMortyTest
//
//  Created by Genuine on 08.04.2020.
//  Copyright © 2020 Genuine. All rights reserved.
//


import UIKit



class ListOfCharacters : UITableViewController,UITableViewDataSourcePrefetching {
   
    private let viewModelNetwork = Network()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.dataSource = self
        tableView?.prefetchDataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func sortButton(_ sender: UIBarButtonItem) {
        viewModelNetwork.characters.sort(by: {$0?.name ?? "sorting name" < $1?.name ?? "sorting name"})
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelNetwork.characters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModelNetwork.fetchCharacters(ofIndex: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell",for: indexPath)
        cell.textLabel?.text = viewModelNetwork.characters[indexPath.row]?.name
        return cell
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            viewModelNetwork.fetchCharacters(ofIndex: indexPath.row) 
        }
    }
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            viewModelNetwork.cancelFetchCharacters(ofIndex: indexPath.row)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailsSegue") {
            if let detailsViewController = segue.destination as? DetailsCharacterController {
                let indexPathForSelectedRow = tableView.indexPathForSelectedRow?.row
                detailsViewController.characterDetails = viewModelNetwork.characters[indexPathForSelectedRow!]!
            }
        }
    }
}

