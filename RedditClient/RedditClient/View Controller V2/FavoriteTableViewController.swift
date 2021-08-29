//
//  FavoriteTableViewController.swift
//  RedditClient
//
//  Created by Tommy Lam on 8/16/21.
//

import UIKit

class FavoriteTableViewController: UITableViewController {

    let userDefaults = UserDefaults.standard
    let userFavouritesKey = "favorites"
    var userFavourites: [String] = []

    @IBOutlet var favouriteTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        userFavourites = retrieveUserFavourites()
    }

    override func viewWillAppear(_ animated: Bool) {
        // unable to update favourites table view asyncronously 
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("favourites count : \(userFavourites.count)")
        return userFavourites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell") as! UITableViewCell
        cell.textLabel?.text = userFavourites[indexPath.row]
        return cell
    }


    // MARK: - User Default logic
    func retrieveUserFavourites() -> [String] {
        guard let favourites = userDefaults.object(forKey: userFavouritesKey) as? [String] else {
            userDefaults.setValue([], forKey: userFavouritesKey)
            return []
        }
        return favourites
    }

}
