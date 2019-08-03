//
//  User.swift
//  Random Users
//
//  Created by Dongwoo Pae on 8/3/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Users: Decodable {
    
    enum resultsKey: String, CodingKey {
        case results
    }
    
    var results: [User]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: resultsKey.self)
        self.results = try container.decode([User].self, forKey: .results)
    }
}

//decoding part with no layers

struct User: Decodable {

    
    enum UserKey: String, CodingKey {
        case name
        case email
        case phone
        case picture

        enum nameKey: String, CodingKey {
            case title
            case first
            case last
        }
    
        enum pictureKey: String, CodingKey {
            case large
            case medium
            case thumbnail
            }
        }
    
    var title: String
    var first: String
    var last: String

    var email: String
    var phone: String

    var large: String
    var medium: String
    var thumbnail: String
    
    //decode with no layers
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKey.self)
        
        //name details
        let nameContainer = try container.nestedContainer(keyedBy: UserKey.nameKey.self, forKey: .name)
            //title
        let nameTitle = try nameContainer.decode(String.self, forKey: .title)
        self.title = nameTitle
            //first
        let first = try nameContainer.decode(String.self, forKey: .first)
        self.first = first
            //last
        let last = try nameContainer.decode(String.self, forKey: .last)
        self.last = last
        
        //email
        self.email = try container.decode(String.self, forKey: .email)
        //phone
        self.phone = try container.decode(String.self, forKey: .phone)
        
        //pictures
        let pictureContainer = try container.nestedContainer(keyedBy: UserKey.pictureKey.self, forKey: .picture)
            //large
        let largePicture = try pictureContainer.decode(String.self, forKey: .large)
        self.large = largePicture
            //medium
        let mediumPicture = try pictureContainer.decode(String.self, forKey: .medium)
        self.medium = mediumPicture
            //thumbnail
        let thumbnailPicture = try pictureContainer.decode(String.self, forKey: .thumbnail)
        self.thumbnail = thumbnailPicture
    }
}


/*
 struct User: Decodable {
 var name: Names
 
 struct Names: Decodable {
 var title: String
 var first: String
 var last: String
 }
 
 var email: String
 var phone: String
 
 var picture: Pictures
 
 struct Pictures: Decodable {
 var large: String
 var thumbnail: String
 }
 }
 */



