//
//  LoadPostViewController.swift
//  RedditClient
//
//  Created by Tommy Lam on 8/20/21.
//

import UIKit

class LoadPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let userDefaults = UserDefaults.standard
    let userFavouritesKey = "favorites"
    var userFavourites: [String] = []
    var selectedThread: String!
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        loadPosts()

        setUpTableView()

        userFavourites = retrieveUserFavourites()
        if userFavourites.contains(selectedThread) {
            let favouriteButton = UIBarButtonItem(title: "Unfavourite", style: .plain, target: self, action: #selector(favoriteTapped))
            self.navigationItem.rightBarButtonItem  = favouriteButton
        } else {
            let favouriteButton = UIBarButtonItem(title: "Favourite", style: .plain, target: self, action: #selector(favoriteTapped))
            self.navigationItem.rightBarButtonItem  = favouriteButton
        }

    }

    @objc func favoriteTapped() {
        print("Favourite Tapped")
        var title = self.navigationItem.rightBarButtonItem?.title
        if title == "Favourite" {
            saveToUserFavorites(favoritesArray: self.userFavourites, savingFavorites: self.selectedThread)
            self.navigationItem.rightBarButtonItem?.title = "Unfavourite"
        } else {
            deleteFromUserFavorites(favoritesArray: self.userFavourites, removingFavorites: self.selectedThread)
            self.navigationItem.rightBarButtonItem?.title = "Favourite"
        }

    }

    // MARK: - User Default logic
    func retrieveUserFavourites() -> [String] {
        guard let favourites = userDefaults.object(forKey: userFavouritesKey) as? [String] else {
            userDefaults.setValue([], forKey: userFavouritesKey)
            return []
        }
        return favourites
    }

    func saveToUserFavorites(favoritesArray: [String], savingFavorites: String) {
        var newFavorites = favoritesArray
        newFavorites.append(savingFavorites)
        userDefaults.setValue(newFavorites, forKey: userFavouritesKey)
    }

    func deleteFromUserFavorites(favoritesArray: [String], removingFavorites: String) {
        var newFavorites = favoritesArray.filter { $0 != removingFavorites}
        userDefaults.setValue(newFavorites, forKey: userFavouritesKey)
    }


    // MARK: - Load post logic
    func loadPosts() {
        let url = RedditAPI.EndPoint.post(selectedThread!).url

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response, error == nil else {
                print("Error")
                return
            }

            do {
                let parsedResponse = try JSONDecoder().decode(Kind<Listing>.self, from: data)
                DispatchQueue.main.async {
                    self.posts = parsedResponse.data.children.map { $0.data }
                    print(self.posts)
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }

    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.author
        loadImageFromURL(url: URL(string: post.thumbnail), cell: cell)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func loadImageFromURL(url: URL?, cell: UITableViewCell) {
        DispatchQueue.global().async {
            guard let url = url, let data = try? Data(contentsOf: url) else {
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                cell.imageView?.image = image
                // solution
                cell.setNeedsLayout() //invalidate current layout
                cell.layoutIfNeeded() //update immediately
                // above solution solves majority of cells, still a few cells require interaction before image loads
            }
        }
    }
}
