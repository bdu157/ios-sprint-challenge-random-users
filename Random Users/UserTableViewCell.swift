//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Dongwoo Pae on 8/3/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailimage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!

    var usersController = UsersController()
    var cache: Cache<String, Data>?
    var user : User? {
        didSet {
            self.updateViews()
        }
    }
    
    private func updateViews() {
        if let user = user {
            self.fullNameLabel.text = "\(user.title) \(user.first) \(user.last)"
            usersController.fetchLargeAndThumbnailImage(at: user.thumbnail) { (result) in
                if let result = try? result.get() {
                    DispatchQueue.main.async {
                        let image = UIImage(data: result)
                        self.thumbnailimage.image = image
                    }
                    guard let passedCache = self.cache else {return}
                        passedCache.cache(value: result, for: user.email)
                }
            }
        }
    }
}
