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
        return cell
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
