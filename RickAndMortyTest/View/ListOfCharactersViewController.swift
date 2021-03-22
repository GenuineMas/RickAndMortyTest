//
//  ListOfCharacters.swift
//  RickAndMortyTest
//
//  Created by Genuine on 08.04.2020.
//  Copyright © 2020 Genuine. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa



class ListOfCharacters : UITableViewController {
   
    private let viewModelNetwork = Network()
    var characters: [Character] = []
     let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.dataSource = self
        //tableView?.prefetchDataSource = self
        let client = Network.shared
            do{
              try client.getCharacters().subscribe(
                onNext: { result in
                    self.characters = result.results
                    print(result.results)
                   //MARK: display in UITableView
                },
                onError: { error in
                   print(error.localizedDescription)
                },
                onCompleted: {
                   print("Completed event.")
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func sortButton(_ sender: UIBarButtonItem) {
        self.characters.sort(by: {$0.name < $1.name })
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //viewModelNetwork.fetchCharacters(ofIndex: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell",for: indexPath)
        cell.textLabel?.text = characters[indexPath.row].name
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailsSegue") {
            if let detailsViewController = segue.destination as? DetailsCharacterController {
                let indexPathForSelectedRow = tableView.indexPathForSelectedRow?.row
                detailsViewController.characterDetails = characters[indexPathForSelectedRow!]
            }
        }
    }
}

