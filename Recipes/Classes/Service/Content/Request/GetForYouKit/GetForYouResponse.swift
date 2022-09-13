//
//  GetForYouResponse.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import Foundation

final class GetForYouResponse {
    static func map(from response: Any) -> ForYouKit? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let freeBookJSON = data["free_book"] as? [String: Any],
            let freeBook = map(coverJSON: freeBookJSON)
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
        let rankings = rankingArray.compactMap { rankingJSON -> RankingBooksGroup? in
            guard
                let id = rankingJSON["ranking_id"] as? Int,
                let booksArray = rankingJSON["books"] as? [[String: Any]]
            else {
                return nil
            }
            
            let books = booksArray.compactMap { coverJSON -> BookCover? in
                map(coverJSON: coverJSON)
            }
            
            return RankingBooksGroup(rankingId: id, books: books)
        }
        
        return ForYouKit(freeBook: freeBook,
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
                         author: author,
                         imageUrl: imageUrl,
                         rankingId: rankingId,
                         shareLink: shareLink,
                         paid: paid)
    }
}
