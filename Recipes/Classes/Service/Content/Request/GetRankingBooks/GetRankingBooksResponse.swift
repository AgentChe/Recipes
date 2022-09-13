//
//  GetRankingBooksResponse.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import Foundation

final class GetRankingBooksResponse {
    static func map(from response: Any) -> [BookCover] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [[String: Any]]
        else {
            return []
        }
        
        return data.compactMap { coverJSON -> BookCover? in
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
}
