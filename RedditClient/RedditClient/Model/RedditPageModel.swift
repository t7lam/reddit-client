//
//  RedditPageModel.swift
//  RedditClient
//
//  Created by Tommy Lam on 8/20/21.
//

import Foundation

struct Kind<T: Decodable>: Decodable {
    let kind: String
    let data: T
}

struct Post: Decodable {
    let title: String
    let author: String
    let thumbnail: String
    let subreddit: String
}

struct Listing: Decodable {
    let after: String
    let children: [Kind<Post>]
}

struct SearchResult: Decodable {
    let names: [String]
}
