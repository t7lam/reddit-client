//
//  SearchTableViewController.swift
//  RedditClient
//
//  Created by Tommy Lam on 8/16/21.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var searchTabTableView: UITableView!

    var searchResult = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResult.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! UITableViewCell
        cell.textLabel?.text = searchResult[indexPath.row]
        return cell
    }

    // MARK: Search Functionalities
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            print(searchText)
            searchResult = []
            let query = searchText.lowercased()
            searchUsingText(text: query)

        } else {
            searchResult = []
        }
    }

    func searchUsingText(text: String) {
        let searchUrl = RedditAPI.EndPoint.searchSubReddit(text).url
        let task = URLSession.shared.dataTask(with: searchUrl) { data, response, error in
            print("Data: ", data)
            guard let data = data, let response = response, error == nil else {
                print("Error getting search data")
                return
            }
            do {
                let parsedData = try JSONDecoder().decode(SearchResult.self, from: data)
                DispatchQueue.main.async {
                    self.searchResult = parsedData.names
                    print("Search Results: ", self.searchResult)
                    self.searchTabTableView.reloadData()
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }


}
