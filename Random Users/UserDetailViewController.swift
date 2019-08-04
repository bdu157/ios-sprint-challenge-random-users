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
            self.nameLabel?.text = "\(user.title) \(user.first) \(user.last)"
            self.phoneNumberLabel?.text = user.phone
            self.emailAddressLabel?.text = user.email
            
            usersController.fetchLargeAndThumbnailImage(at: user.large, completion: { (result) in
                if let result = try? result.get() {
                    DispatchQueue.main.async {
                        let image = UIImage(data: result)
                        self.largeImageView.image = image
                    }
                    guard let passedCache = self.cache else {return}
                    passedCache.cache(value: result, for: user.email)
                }
            })
        }
    }
}

