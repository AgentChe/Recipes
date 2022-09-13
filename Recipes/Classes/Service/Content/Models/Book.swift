//
//  Book.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import Foundation

struct Book: Codable, Hashable {
    let id: Int
    let name: String
    let imageUrl: URL
    let author: Author
    let rankingId: Int
    let time: Int
    let audioUrl: URL
    let shareLink: URL
    let isSaved: Bool
    let introduction: BookChapter?
    let chapters: [BookChapter]
    let whatAbout: String
}
