//
//  GetExploreKitResponse.swift
//  Recipes
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import Foundation

final class GetExploreKitResponse {
    static func map(from response: Any) -> [RecipeCover] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let trendingSearchesArray = data["trending_searches"] as? [[String: Any]]
        else {
            return []
        }
        
        return trendingSearchesArray.compactMap { coverJSON -> RecipeCover? in
            guard
                let id = coverJSON["id"] as? Int,
                let name = coverJSON["name"] as? String,
                let imagePath = coverJSON["image"] as? String,
                let imageUrl = URL(string: imagePath),
                let rankingId = coverJSON["ranking_id"] as? Int,
                let shareLinkPath = coverJSON["link"] as? String,
                let shareLink = URL(string: shareLinkPath),
                let paid = coverJSON["paid"] as? Bool
            else {
                return nil
            }
            
            let timePreparing = coverJSON["time_preparing"] as? Int
            let timeCooking = coverJSON["time_cooking"] as? Int
            
            return RecipeCover(id: id,
                               name: name,
                               timePreparing: timePreparing,
                               timeCooking: timeCooking,
                               imageUrl: imageUrl,
                               rankingId: rankingId,
                               shareLink: shareLink,
                               paid: paid)
        }
    }
}
