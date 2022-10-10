//
//  SearchRecipesResponse.swift
//  Recipes
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import Foundation

final class SearchRecipesResponse {
    static func map(from response: Any) -> [RecipeCover] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [[String: Any]]
        else {
            return []
        }
        
        return data.compactMap { coverJSON -> RecipeCover? in
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
    }
}
