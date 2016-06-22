//
//  Gnome.swift
//  GnomesBook
//
//  Created by Mario Martinez on 18/6/16.
//  Copyright © 2016 Brastlewark Town. All rights reserved.
//

import UIKit
import Alamofire

final class Gnome: ResponseObjectSerializable, ResponseCollectionSerializable {
    let id: Int
    let name: String
    let surname: String
    let fullName: String
    let thumbnail: String
    let age: Int
    let weight: Float
    let height: Float
    let hairColor: String
    let professions: Array<String>
    let friends: Array<String>
    
    init() {
        self.id = 0
        self.name = ""
        self.surname = ""
        self.fullName = ""
        self.thumbnail = ""
        self.age = 0
        self.weight = 0.0
        self.height = 0.0
        self.hairColor = ""
        self.professions = Array<String>()
        self.friends = Array<String>()
    }
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.id = representation["id"] as! Int
        
        let fullName = representation["name"] as! String
        var fullNameArr = fullName.componentsSeparatedByString(" ")
        
        self.name = fullNameArr[1]
        self.surname = fullNameArr[0]
        self.fullName = fullName
        self.thumbnail = representation["thumbnail"] as! String
        self.age = representation["age"] as! Int
        self.weight = representation["weight"] as! Float
        self.height = representation["height"] as! Float
        self.hairColor = representation["hair_color"] as! String
        self.professions = representation["professions"] as! Array
        self.friends = representation["friends"] as! Array
    }
}


