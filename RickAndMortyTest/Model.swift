//
//  Model.swift
//  RickAndMortyTest
//
//  Created by Genuine on 13.04.2020.
//  Copyright © 2020 Genuine. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct RawServerResponse: Codable {
    let info: Info
    let results: [Character]
}

// MARK: - Info
struct Info: Codable {
    let count, pages: Int
    let next: String
    let prev: String?
}
   
struct Character: Codable {

    var id: Int
    var name: String
    var status: String
    var image:String
    var species:String
    var gender:String

}




