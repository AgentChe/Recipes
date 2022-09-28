//
//  ExploreKit.swift
//  Recipes
//
//  Created by Андрей Чернышев on 12.07.2022.
//

struct ExploreKit: Codable, Hashable {
    let trendingSearches: [BookCover]
    let popularRequests: [String]
}
