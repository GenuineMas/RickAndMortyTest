//
//  ViewModel.swift
//  RickAndMortyTest
//
//  Created by Genuine on 19.03.2021.
//  Copyright © 2021 Genuine. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit


//MARK: RequestObservable class
public class RequestObservable {
    private lazy var jsonDecoder = JSONDecoder()
    private var urlSession: URLSession
    public init(config:URLSessionConfiguration) {
        urlSession = URLSession(configuration:
                                    URLSessionConfiguration.default)
    }
    //MARK: function for URLSession takes
    public func callAPI<ItemModel: Decodable>(request: URLRequest)
    -> Observable<ItemModel> {
        //MARK: creating our observable
        return Observable.create { observer in
            //MARK: create URLSession dataTask
            let task = self.urlSession.dataTask(with: request) { (data,
                                                                  response, error) in
                if let httpResponse = response as? HTTPURLResponse{
                    let statusCode = httpResponse.statusCode
                    do {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            let objs = try self.jsonDecoder.decode(ItemModel.self, from:
                                                                    _data)
                            //MARK: observer onNext event
                            observer.onNext(objs)
                        }
                        else {
                            observer.onError(error!)
                        }
                    } catch {
                        //MARK: observer onNext event
                        observer.onError(error)
                    }
                }
                //MARK: observer onCompleted event
                observer.onCompleted()
            }
            task.resume()
            //MARK: return our disposable
            return Disposables.create {
                task.cancel()
            }
        }
    }
}



class Network {
    
    static var shared = Network()
    lazy var requestObservable = RequestObservable(config: .default)
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
    
    func getCharacters() throws -> Observable<RawServerResponse> {
        var request = URLRequest(url: URL(string:"https://rickandmortyapi.com/api/character/")!)
        request.httpMethod = "GET"
        return requestObservable.callAPI(request: request)
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
