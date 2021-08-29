//
//  LoadPostViewController.swift
//  RedditClient
//
//  Created by Tommy Lam on 8/20/21.
//

import UIKit

class LoadPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        loadPosts()

        setUpTableView()
    }

    func loadPosts() {
        print("test")
        guard let url = URL(string: "https://www.reddit.com/r/aww/.json") else {
            fatalError("URL Failure")
            return
        }

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
