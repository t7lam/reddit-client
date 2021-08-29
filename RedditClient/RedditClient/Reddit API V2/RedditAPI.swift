//
//  RedditAPI.swift
//  RedditClient
//
//  Created by Tommy Lam on 8/16/21.
//

import Foundation
import UIKit

class RedditAPI {

    enum EndPoint {
        static var baseUrl = "https://www.reddit.com/"
        case searchSubReddit(String)
        case post(String)
        var urlString: String{
            switch self {
            case .searchSubReddit(let searchText):
                return EndPoint.baseUrl + "api/search_reddit_names.json?query=" + searchText
            case .post(let selectedThread):
                return EndPoint.baseUrl + "r/\(selectedThread)/.json"
            }
        }
        var url: URL {
            return URL(string: urlString)!
        }
    }

// /api/search_subreddits
}
