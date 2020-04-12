//
//  ViewController.swift
//  RickAndMortyTest
//
//  Created by Genuine on 08.04.2020.
//  Copyright © 2020 Genuine. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    @IBAction func startButton(_ sender: UIButton) {
        performSegue(withIdentifier: "listOfCharacters", sender: self)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

