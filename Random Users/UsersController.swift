//
//  UsersControllers.swift
//  Random Users
//
//  Created by Dongwoo Pae on 8/3/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class UsersController {
    
    var users : Users!  //this is [User]
    
    var baseURL = URL(string: "https://randomuser.me/api/")!
    
    //https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000
    func getUsers(resultsNumber: Int = 1000, completion: @escaping (Error?)-> Void) {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let formatQueryItem = URLQueryItem(name: "format", value: "json")
        let incQueryItem = URLQueryItem(name: "inc", value: "name,email,phone,picture")
        let resultQueryItem = URLQueryItem(name: "results", value: String(resultsNumber))
        urlComponents?.queryItems = [formatQueryItem, incQueryItem,resultQueryItem]
        
        guard let requestURL = urlComponents?.url else {
            NSLog("there is no URL")
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("there is an error :\(error)")
                completion(NSError())
                return
            }
            
            guard let data = data else {
                NSLog("there is an error: no data")
                completion(NSError())
                return
            }
            
            let jsonDecdoer = JSONDecoder()
            
            do {
                let userDatas = try jsonDecdoer.decode(Users.self, from: data)
                self.users = userDatas
                print(userDatas)
                completion(nil)
            } catch {
                NSLog("unable to complete decoding \(error)")
                completion(error)
            }
        }.resume()
    }
}
