//
//  GetForYouResponse.swift
//  Recipes
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import Foundation

final class GetForYouResponse {
    static func map(from response: Any) -> ForYouKit? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let freeRecipeJSON = data["free_unit"] as? [String: Any],
            let freeRecipe = map(coverJSON: freeRecipeJSON)
        else {
            return nil
        }
        
        let todaysHotSummariesArray = data["todays_hot_summaries"] as? [[String: Any]] ?? []
        let todaysHotSummaries = todaysHotSummariesArray.compactMap { coverJSON -> BookCover? in
            map(coverJSON: coverJSON)
        }
        
        let challengesArray = data["challenges"] as? [[String: Any]] ?? []
        let challenges = challengesArray.compactMap { challengeJSON -> ChallengeCover? in
            guard
                let id = challengeJSON["id"] as? Int,
                let name = challengeJSON["name"] as? String,
                let title = challengeJSON["title"] as? String,
                let imagePath = challengeJSON["image"] as? String,
                let imageUrl = URL(string: imagePath),
                let paid = challengeJSON["paid"] as? Bool
            else {
                return nil
            }
            
            return ChallengeCover(id: id,
                                  name: name,
                                  title: title,
                                  imageUrl: imageUrl,
                                  paid: paid)
        }
        
        let youMayLikeArray = data["you_may_like"] as? [[String: Any]] ?? []
        let youMayLike = youMayLikeArray.compactMap { coverJSON -> BookCover? in
            map(coverJSON: coverJSON)
        }
        
        let rankingArray = data["ranking"] as? [[String: Any]] ?? []
        let rankings = rankingArray.compactMap { rankingJSON -> RankingRecipesGroup? in
            guard
                let id = rankingJSON["ranking_id"] as? Int,
                let recipesArray = rankingJSON["units"] as? [[String: Any]]
            else {
                return nil
            }
            
            let recipes = recipesArray.compactMap { coverJSON -> BookCover? in
                map(coverJSON: coverJSON)
            }
            
            return RankingRecipesGroup(rankingId: id, recipes: recipes)
        }
        
        return ForYouKit(freeRecipe: freeRecipe,
                         todaysHotSummaries: todaysHotSummaries,
                         challenges: challenges,
                         youMayLike: youMayLike,
                         rankings: rankings)
    }
}

// MARK: Private
private extension GetForYouResponse {
    static func map(coverJSON: [String: Any]) -> BookCover? {
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
        
        return BookCover(id: id,
                         name: name,
                         time: time,
                         author: author,
                         imageUrl: imageUrl,
                         rankingId: rankingId,
                         shareLink: shareLink,
                         paid: paid)
    }
}
