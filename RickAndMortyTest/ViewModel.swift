//
//  ViewModel.swift
//  RickAndMortyTest
//
//  Created by Genuine on 19.03.2021.
//  Copyright © 2021 Genuine. All rights reserved.
//

import Foundation
import UIKit



class Network {
    
    var characters = [Character?](repeating: nil, count: 493)
    let characterID = [Int](1...493)
    var dataTasks : [URLSessionDataTask] = []
    
    
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

extension UIButton {
    
    func startAnimatingPressActions() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5))
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 6,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform
            }, completion: nil)
    }
    
}
