//
//  ForYouKit.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 12.07.2022.
//

struct ForYouKit: Codable, Hashable {
    let freeBook: BookCover
    let todaysHotSummaries: [BookCover]
    let challenges: [ChallengeCover]
    let youMayLike: [BookCover]
    let rankings: [RankingBooksGroup]
}
