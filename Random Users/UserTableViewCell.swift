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
    
    var user : User? {
        didSet {
            self.updateViews()
        }
    }
    
    private func updateViews() {
        if let user = user {
            self.fullNameLabel.text = "\(user.title) \(user.first) \(user.last)"
        }
    }
}
