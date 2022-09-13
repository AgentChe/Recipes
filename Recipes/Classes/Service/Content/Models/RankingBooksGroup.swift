//
//  RankingBooksGroup.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 13.07.2022.
//

struct RankingBooksGroup: Codable, Hashable {
    let rankingId: Int
    let books: [BookCover]
}
