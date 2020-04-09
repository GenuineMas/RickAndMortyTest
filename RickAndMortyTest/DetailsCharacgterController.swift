//
//  DetailsCharacterController.swift
//  RickAndMortyTest
//
//  Created by Genuine on 08.04.2020.
//  Copyright © 2020 Genuine. All rights reserved.
//

import UIKit

class DetailsCharacterCell: UITableViewCell {
    @IBOutlet weak var detailsImage: UIImageView!
}
class DetailsCharacterController: UITableViewController {
    
    var characterImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsOfCharacter", for: indexPath) as! DetailsCharacterCell
        cell.detailsImage.load(url: URL(string: characterImage)!)
        return cell
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
