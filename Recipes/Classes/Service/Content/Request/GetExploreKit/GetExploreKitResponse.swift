//
//  GetExploreKitResponse.swift
//  Recipes
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import Foundation

final class GetExploreKitResponse {
    static func map(from response: Any) -> ExploreKit? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        let trendingSearchesArray = data["trending_searches"] as? [[String: Any]] ?? []
        let trendingSearches = trendingSearchesArray.compactMap { coverJSON -> RecipeCover? in
            guard
                let id = coverJSON["id"] as? Int,
                let name = coverJSON["name"] as? String,
                let time = coverJSON["time_min"] as? Int,
                let imagePath = coverJSON["image"] as? String,
                let imageUrl = URL(string: imagePath),
                let rankingId = coverJSON["ranking_id"] as? Int,
                let shareLinkPath = coverJSON["link"] as? String,
                let shareLink = URL(string: shareLinkPath),
                let paid = coverJSON["paid"] as? Bool
            else {
                return nil
            }
            
            return RecipeCover(id: id,
                             name: name,
                             time: time,
                             imageUrl: imageUrl,
                             rankingId: rankingId,
                             shareLink: shareLink,
                             paid: paid)
        }
        
        let popularRequests = data["popular_requests"] as? [String] ?? []
        
        return ExploreKit(trendingSearches: trendingSearches,
                          popularRequests: popularRequests)
    }
}
