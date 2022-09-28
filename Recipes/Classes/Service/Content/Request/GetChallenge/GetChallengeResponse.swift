//
//  GetChallengeResponse.swift
//  Recipes
//
//  Created by Андрей Чернышев on 12.08.2022.
//

import Foundation

final class GetChallengeResponse {
    static func map(from response: Any) -> Challenge? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        guard
            let id = data["id"] as? Int,
            let name = data["name"] as? String,
            let title = data["title"] as? String,
            let text = data["text"] as? String,
            let imagePath = data["image"] as? String,
            let imageUrl = URL(string: imagePath)
        else {
            return nil
        }
        
        let recipesArray = data["units"] as? [[String: Any]] ?? []
        let recipes = recipesArray.compactMap { coverJSON -> RecipeCover? in
            guard
                let id = coverJSON["id"] as? Int,
                let name = coverJSON["name"] as? String,
                let time = coverJSON["time_min"] as? Int,
                let authorJSON = coverJSON["author"] as? [String: Any],
                let authorName = authorJSON["name"] as? String,
                let authorImagePath = authorJSON["photo_url"] as? String,
                let authorImageUrl = URL(string: authorImagePath),
                let imagePath = coverJSON["image"] as? String,
                let imageUrl = URL(string: imagePath),
                let rankingId = coverJSON["ranking_id"] as? Int,
                let shareLinkPath = coverJSON["link"] as? String,
                let shareLink = URL(string: shareLinkPath),
                let paid = coverJSON["paid"] as? Bool
            else {
                return nil
            }
            
            let author = Author(name: authorName,
                                photoUrl: authorImageUrl)
            
            return RecipeCover(id: id,
                             name: name,
                             time: time,
                             author: author,
                             imageUrl: imageUrl,
                             rankingId: rankingId,
                             shareLink: shareLink,
                             paid: paid)
        }
        
        return Challenge(id: id,
                         name: name,
                         title: title,
                         text: text,
                         imageUrl: imageUrl,
                         recipes: recipes)
    }
}
