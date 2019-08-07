//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Dongwoo Pae on 8/3/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    var usersController: UsersController?
    var user: User?
    var cache: Cache<String, Data>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    private func updateViews() {
        if let user = user,
            let usersController = usersController {
            let title = user.title.capitalized
            let first = user.first.capitalized
            let last = user.last.capitalized
            self.nameLabel?.text = "\(title) \(first) \(last)"
            self.phoneNumberLabel?.text = user.phone
            self.emailAddressLabel?.text = user.email
            
            
            //using phone to differentiate cached largeImage from cached thumbnail image which is using email as its key
            if let cachedValue = self.cache?.value(for: user.phone) {
                let image = UIImage(data: cachedValue)
                self.largeImageView.image = image
                print("large image being shown from cachedValue")
            } else {
            
            usersController.fetchLargeImage(at: user.large, completion: { (result) in
                if let result = try? result.get() {
                    DispatchQueue.main.async {
                        let image = UIImage(data: result)
                        self.largeImageView.image = image
                        print("fetchLargeImage closure being called")
                    }
                    self.cache?.cache(value: result, for: user.phone)  //caching the data
                    print("caching for largeImage: \(user.phone)")
                    }
                })
            }
        }
    }
}

