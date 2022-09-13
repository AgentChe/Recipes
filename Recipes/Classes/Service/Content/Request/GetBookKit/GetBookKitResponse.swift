//
//  GetBookKitResponse.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import Foundation

final class GetBookKitResponse {
    static func map(from response: Any) -> BookKit? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        guard
            let id = data["id"] as? Int,
            let name = data["name"] as? String,
            let imagePath = data["image"] as? String,
            let imageUrl = URL(string: imagePath),
            let authorJSON = data["author"] as? [String: Any],
            let authorName = authorJSON["name"] as? String,
            let authorImagePath = authorJSON["photo_url"] as? String,
            let authorImageUrl = URL(string: authorImagePath),
            let rankingId = data["ranking_id"] as? Int,
            let time = data["time_min"] as? Int,
            let audioPath = data["audio"] as? String,
            let audioUrl = URL(string: audioPath),
            let shareLinkPath = data["link"] as? String,
            let shareLink = URL(string: shareLinkPath),
            let isSaved = data["saved"] as? Bool,
            let whatAbout = data["what_about"] as? String
        else {
            return nil
        }
        
        let author = Author(name: authorName,
                            photoUrl: authorImageUrl)
        
        let introductionJSON = data["introduction"] as? [String: Any] ?? [:]
        let introduction = map(introductionJSON: introductionJSON)
        
        let chaptersArray = data["chapters"] as? [[String: Any]] ?? []
        let chapters = chaptersArray.compactMap { chapterJSON -> BookChapter? in
            guard
                let shortDescription = chapterJSON["short"] as? String,
                let title = chapterJSON["title"] as? String,
                let text = chapterJSON["text"] as? String
            else {
                return nil
            }
            
            return BookChapter(shortDescription: shortDescription,
                               title: title,
                               text: text)
        }
        
        let book = Book(id: id,
                        name: name,
                        imageUrl: imageUrl,
                        author: author,
                        rankingId: rankingId,
                        time: time,
                        audioUrl: audioUrl,
                        shareLink: shareLink,
                        isSaved: isSaved,
                        introduction: introduction,
                        chapters: chapters,
                        whatAbout: whatAbout)
        
        let similarBooksArray = data["similar_books"] as? [[String: Any]] ?? []
        let similarBooks = similarBooksArray.compactMap { coverJSON -> BookCover? in
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
        
        return BookKit(book: book,
                       similarBooks: similarBooks)
    }
}

// MARK: Private
private extension GetBookKitResponse {
    static func map(introductionJSON: [String: Any]) -> BookChapter? {
        guard
            let title = introductionJSON["title"] as? String,
            let text = introductionJSON["text"] as? String
        else {
            return nil
        }
        
        return BookChapter(shortDescription: "",
                           title: title,
                           text: text)
    }
}
