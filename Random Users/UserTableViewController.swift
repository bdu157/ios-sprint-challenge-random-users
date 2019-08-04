//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Dongwoo Pae on 8/3/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {

    var usersController = UsersController()
    var cache = Cache<String, Data>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usersController.getUsers { (error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        //fetching Thumbnail photos
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersController.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        guard let customCell = cell as? UserTableViewCell else {return UITableViewCell()}
            let user = usersController.users[indexPath.row]
            customCell.user = user
            self.loadImage(forCell: customCell, forRowAt: indexPath)
        return cell
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forRowAt indexPath: IndexPath) {
        let user = usersController.users[indexPath.row]
        
        //loadImage - fetchImage could be used here as well but since we will need to remove this for NSOperation we will just go with a separate one
        if let cachedValue = cache.value(for: user.email) {
            let image = UIImage(data: cachedValue)
            cell.thumbnailimage.image = image
        }


        let request = URL(string: user.thumbnail)!
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                NSLog("there is an error in getting a data")
                return
            }
            
            guard let image = UIImage(data: data) else {
                return
            }
            //caching here
            self.cache.cache(value: data, for: user.email)
        
            DispatchQueue.main.sync {
                cell.imageView?.image = image
            }
        }.resume()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToUserDetailVC" {
            guard let destVC = segue.destination as? UserDetailViewController,
                let selectedRow = tableView.indexPathForSelectedRow else {return}
            destVC.usersController = self.usersController
            destVC.user = self.usersController.users[selectedRow.row]
        }
    }

}
