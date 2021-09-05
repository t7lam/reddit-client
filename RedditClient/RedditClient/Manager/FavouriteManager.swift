//
//  FavoriteManager.swift
//  RedditClient
//
//  Created by Tommy Lam on 9/4/21.
//

import Foundation

class FavouriteManager {
    private static let userDefaults = UserDefaults.standard
    private static let userFavouritesKey = "favorites"

    func retrieveUserFavourites() -> [String] {
        guard let favourites = FavouriteManager.userDefaults.object(forKey: FavouriteManager.userFavouritesKey) as? [String] else {
            FavouriteManager.userDefaults.setValue([], forKey: FavouriteManager.userFavouritesKey)
            return []
        }
        return favourites
    }

    func saveToUserFavorites(itemToSave: String) {
        var favourites = retrieveUserFavourites()
        guard !favourites.contains(itemToSave) else {
            print("already exist")
            return
        }
        favourites.append(itemToSave)
        FavouriteManager.userDefaults.setValue(favourites, forKey: FavouriteManager.userFavouritesKey)
    }

    func deleteFromUserFavorites(favouritesArray: [String], removingFavourites: String) {
        var newFavourites = favouritesArray.filter { $0 != removingFavourites}
        FavouriteManager.userDefaults.setValue(newFavourites, forKey: FavouriteManager.userFavouritesKey)
    }

}
