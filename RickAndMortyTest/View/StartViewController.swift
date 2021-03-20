//
//  ViewController.swift
//  RickAndMortyTest
//
//  Created by Genuine on 08.04.2020.
//  Copyright © 2020 Genuine. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa



class ViewController: UIViewController {
    
    var characters: [Character] = []
     let disposeBag = DisposeBag()
    
    
    @IBAction func startButton(_ sender: UIButton) {
        if sender.isFirstResponder {
        sender.startAnimatingPressActions()
        }else {
            print ("No animation")
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {  [weak self] in  //  to remove retain cycle
            self?.performSegue(withIdentifier: "listOfCharacters", sender: self)
        }
    }
    override func viewDidLoad() {

        super.viewDidLoad()
        
        
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
        // Do any additional setup after loading the view.
    }

}

